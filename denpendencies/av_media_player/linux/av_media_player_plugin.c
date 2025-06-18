#include "include/av_media_player/av_media_player_plugin.h"
#include <flutter_linux/flutter_linux.h>
#include <locale.h>
#include <gdk/gdkx.h>
#include <gdk/gdkwayland.h>
#include <epoxy/egl.h>
#include <epoxy/glx.h>
#include <mpv/client.h>
#include <mpv/render_gl.h>
#include <unicode/uloc.h>

/* player class */
#define AV_MEDIA_PLAYER(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), av_media_player_get_type(), AvMediaPlayer))
typedef struct {
	FlTextureGL parent_instance;
	mpv_opengl_fbo fbo;
	mpv_handle* mpv;
	mpv_render_context* mpvRenderContext;
	FlTextureRegistrar* textureRegistrar;
	FlEventChannel* eventChannel;
	gchar* source;
	int64_t id;
	int64_t position;
	int64_t bufferPosition;
	double speed;
	double volume;
	GArray* videoTracks; // video tracks with id, width, height
	GLuint texture;
	GLsizei width;
	GLsizei height;
	uint16_t overrideVideo; // 0 for auto otherwise track id
	uint16_t overrideAudio;
	uint16_t overrideSubtitle;
	uint16_t maxWidth; // 0 for auto
	uint16_t maxHeight;
	bool looping;
	bool streaming;
	bool networking;
	uint8_t state; // 0: idle, 1: opening, 2: paused, 3: playing
} AvMediaPlayer;
typedef struct {
	FlTextureGLClass parent_class;
} AvMediaPlayerClass;
G_DEFINE_TYPE(AvMediaPlayer, av_media_player, fl_texture_gl_get_type())

/* plugin class */
#define AV_MEDIA_PLAYER_PLUGIN(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), av_media_player_plugin_get_type(), AvMediaPlayerPlugin))
typedef struct {
	GObject parent_instance;
	FlMethodCodec* codec;
	FlBinaryMessenger* messenger;
	FlTextureRegistrar* textureRegistrar;
	FlMethodChannel* methodChannel;
	GTree* players; // all write operations on the tree are done in the main thread
	GMutex mutex;   // so we just need to lock the mutex when reading in other threads
} AvMediaPlayerPlugin;
typedef struct {
	GObjectClass parent_class;
} AvMediaPlayerPluginClass;
G_DEFINE_TYPE(AvMediaPlayerPlugin, av_media_player_plugin, g_object_get_type())

static AvMediaPlayerPlugin* plugin;

static gint compare_key(gconstpointer a, gconstpointer b) {
	int64_t i = (int64_t)a;
	int64_t j = (int64_t)b;
	if (i > j) {
		return 1;
	} else if (i < j) {
		return -1;
	} else {
		return 0;
	}
}

static gboolean release_object_on_tree(gpointer key, gpointer value, gpointer obj) {
	g_object_unref(value);
	return FALSE;
}

/* player implementation */
static gboolean av_media_player_is_eof(AvMediaPlayer* self) {
	gboolean eof;
	mpv_get_property(self->mpv, "eof-reached", MPV_FORMAT_FLAG, &eof);
	return eof;
}

static int64_t av_media_player_get_pos(AvMediaPlayer* self) {
	double pos;
	mpv_get_property(self->mpv, "time-pos/full", MPV_FORMAT_DOUBLE, &pos);
	return (int64_t)(pos * 1000);
}

static void av_media_player_set_pause(AvMediaPlayer* self, gboolean pause) {
	mpv_set_property(self->mpv, "pause", MPV_FORMAT_FLAG, &pause);
}

static void av_media_player_rewind(AvMediaPlayer* self) {
	const gchar* cmd[] = { "seek", "0.1", "absolute+keyframes", NULL }; //use 0.1 instead of 0 to workaround mpv bug
	mpv_command(self->mpv, cmd);
}

static void av_media_player_close(AvMediaPlayer* self) {
	self->state = 0;
	self->width = 0;
	self->height = 0;
	self->position = 0;
	self->bufferPosition = 0;
	self->overrideVideo = 0;
	self->overrideAudio = 0;
	self->overrideSubtitle = 0;
	if (self->source) {
		g_free(self->source);
		self->source = NULL;
	}
	g_array_set_size(self->videoTracks, 0);
	const gchar* stop[] = { "stop", NULL };
	mpv_command(self->mpv, stop);
	const gchar* clear[] = { "playlist-clear", NULL };
	mpv_command(self->mpv, clear);
}

static void av_media_player_open(AvMediaPlayer* self, const gchar* source) {
	av_media_player_close(self);
	int result;
	if (g_str_has_prefix(source, "asset://")) {
		g_autoptr(FlDartProject) project = fl_dart_project_new();
		gchar* path = g_strdup_printf("%s%s", fl_dart_project_get_assets_path(project), &source[7]);
		const gchar* cmd[] = { "loadfile", path, NULL };
		result = mpv_command(self->mpv, cmd);
		g_free(path);
	} else {
		const gchar* cmd[] = { "loadfile", source, NULL };
		result = mpv_command(self->mpv, cmd);
	}
	if (result == 0) {
		self->state = 1;
		self->source = g_strdup(source);
		av_media_player_set_pause(self, TRUE);
	} else {
		g_autoptr(FlValue) evt = fl_value_new_map();
		fl_value_set_string_take(evt, "event", fl_value_new_string("error"));
		fl_value_set_string_take(evt, "event", fl_value_new_string(mpv_error_string(result)));
		fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
	}
}

static void av_media_player_play(AvMediaPlayer* self) {
	if (self->state == 2) {
		self->state = 3;
		if (av_media_player_is_eof(self)) {
			av_media_player_rewind(self);
		}
		av_media_player_set_pause(self, FALSE);
	}
}

static void av_media_player_pause(AvMediaPlayer* self) {
	if (self->state > 2) {
		self->state = 2;
		av_media_player_set_pause(self, TRUE);
	}
}

static void av_media_player_seek_to(AvMediaPlayer* self, const int64_t position) {
	if (self->state < 2 || self->streaming || av_media_player_get_pos(self) == position) {
		g_autoptr(FlValue) evt = fl_value_new_map();
		fl_value_set_string_take(evt, "event", fl_value_new_string("seekEnd"));
		fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
	} else if (self->state > 1) {
		gchar* t = g_strdup_printf("%lf", (double)position / 1000);
		const gchar* cmd[] = { "seek", t, "absolute", NULL };
		mpv_command(self->mpv, cmd);
		g_free(t);
	}
}

static void av_media_player_set_speed(AvMediaPlayer* self, const double speed) {
	self->speed = speed;
	mpv_set_property(self->mpv, "speed", MPV_FORMAT_DOUBLE, &self->speed);
}

static void av_media_player_set_volume(AvMediaPlayer* self, const double volume) {
	self->volume = volume * 100;
	mpv_set_property(self->mpv, "volume", MPV_FORMAT_DOUBLE, &self->volume);
}

static void av_media_player_set_looping(AvMediaPlayer* self, const bool looping) {
	self->looping = looping;
}

static void av_media_player_set_show_subtitle(AvMediaPlayer* self, const bool show) {
	mpv_set_property_string(self->mpv, "sub-visibility", show ? "yes" : "no");
}

static void av_media_player_set_preferred_audio_language(AvMediaPlayer* self, const gchar* language) {
	mpv_set_property_string(self->mpv, "alang", language);
}

static void av_media_player_set_preferred_subtitle_language(AvMediaPlayer* self, const gchar* language) {
	mpv_set_property_string(self->mpv, "slang", language);
}

static void av_media_player_set_max_bitrate(AvMediaPlayer* self, uint32_t bitrate) {
	mpv_set_property(self->mpv, "hls-bitrate", MPV_FORMAT_INT64, &bitrate);
}

static void av_media_player_set_max_resolution_real(AvMediaPlayer* self) {
	if (self->overrideVideo == 0) {
		if (self->maxWidth > 0 || self->maxHeight > 0) {
			uint16_t id = 0;
			uint32_t maxRes = 0;
			uint16_t minId = 0;
			uint32_t minRes = UINT32_MAX;
			for (uint i = 0; i < self->videoTracks->len; i++) {
				uint16_t* data = &g_array_index(self->videoTracks, uint16_t, i * 3);
				uint32_t res = data[1] * data[2];
				if ((self->maxWidth == 0 || data[1] <= self->maxWidth) && (self->maxHeight == 0 || data[2] <= self->maxHeight) && res > maxRes) {
					id = data[0];
					maxRes = res;
				}
				if (id == 0 && res < minRes) {
					minId = data[0];
					minRes = res;
				}
			}
			if (id == 0) {
				id = minId;
			}
			if (id != 0) {
				char p[8];
				sprintf(p, "%d", id);
				mpv_set_property_string(self->mpv, "vid", p);
			}
		} else {
			mpv_set_property_string(self->mpv, "vid", "auto");
		}
	}
}

static void av_media_player_set_max_resolution(AvMediaPlayer* self, const uint16_t width, const uint16_t height) {
	self->maxWidth = width;
	self->maxHeight = height;
	if (self->state > 1) {
		av_media_player_set_max_resolution_real(self);
	}
}

static void av_media_player_overrideTrack(AvMediaPlayer* self, const uint8_t typeId, uint16_t trackId, bool enabled) {
	if (self->state > 1) {
		char p[8];
		if (enabled) {
			sprintf(p, "%d", trackId);
		} else {
			sprintf(p, "auto");
			trackId = 0;
		}
		if (typeId == 0) {
			self->overrideVideo = trackId;
			mpv_set_property_string(self->mpv, "vid", p);
		} else if (typeId == 1) {
			self->overrideAudio = trackId;
			mpv_set_property_string(self->mpv, "aid", p);
		} else if (typeId == 2) {
			self->overrideSubtitle = trackId;
			mpv_set_property_string(self->mpv, "sid", p);
		}
	}
}

static void* gl_init(void* data, const char* name) {
	size_t type = (size_t)data; //2: wayland, 1: x11
	if (type == 2) {
		return eglGetProcAddress(name);
	} else if (type == 1) {
		return glXGetProcAddressARB((const GLubyte*)name);
	} else {
		return NULL;
	}
}

static gboolean event_callback(void* id) {
	AvMediaPlayer* self = g_tree_lookup(plugin->players, id);
	while (self) {
		mpv_event* event = mpv_wait_event(self->mpv, 0);
		if (event->event_id == MPV_EVENT_NONE) {
			break;
		} else if (self->state > 0) {
			if (event->event_id == MPV_EVENT_PROPERTY_CHANGE) {
				mpv_event_property* detail = (mpv_event_property*)event->data;
				if (detail->data) {
					if (g_str_equal(detail->name, "time-pos/full")) {
						if (self->state > 1 && !self->streaming) {
							int64_t pos = (int64_t)(*(double*)detail->data * 1000);
							if (self->position != pos) {
								self->position = pos;
								g_autoptr(FlValue) evt = fl_value_new_map();
								fl_value_set_string_take(evt, "event", fl_value_new_string("position"));
								fl_value_set_string_take(evt, "value", fl_value_new_int(self->position));
								fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
							}
						}
					} else if (g_str_equal(detail->name, "demuxer-cache-time")) {
						if (self->networking) {
							self->bufferPosition = (int64_t)(*(double*)detail->data * 1000);
							g_autoptr(FlValue) evt = fl_value_new_map();
							fl_value_set_string_take(evt, "event", fl_value_new_string("buffer"));
							fl_value_set_string_take(evt, "begin", fl_value_new_int(av_media_player_get_pos(self)));
							fl_value_set_string_take(evt, "end", fl_value_new_int(self->bufferPosition));
							fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
						}
					} else if (g_str_equal(detail->name, "paused-for-cache")) {
						if (self->state > 2) {
							g_autoptr(FlValue) evt = fl_value_new_map();
							fl_value_set_string_take(evt, "event", fl_value_new_string("loading"));
							fl_value_set_string_take(evt, "value", fl_value_new_bool(*(gboolean*)detail->data));
							fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
						}
					} else if (g_str_equal(detail->name, "pause")) { //listen to pause instead of eof-reached to workaround mpv bug
						if (self->state > 2 && *(gboolean*)detail->data && av_media_player_is_eof(self)) {
							if (self->streaming) {
								av_media_player_close(self);
							} else if (self->looping) {
								av_media_player_rewind(self);
								av_media_player_set_pause(self, FALSE);
							} else {
								self->state = 2;
							}
							g_autoptr(FlValue) evt = fl_value_new_map();
							fl_value_set_string_take(evt, "event", fl_value_new_string("finished"));
							fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
						}
					}
				}
			} else if (event->event_id == MPV_EVENT_END_FILE) {
				mpv_event_end_file* detail = (mpv_event_end_file*)event->data;
				if (detail->reason == MPV_END_FILE_REASON_ERROR) {
					av_media_player_close(self);
					g_autoptr(FlValue) evt = fl_value_new_map();
					fl_value_set_string_take(evt, "event", fl_value_new_string("error"));
					fl_value_set_string_take(evt, "value", fl_value_new_string(mpv_error_string(detail->error)));
					fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
				}
			} else if (event->event_id == MPV_EVENT_FILE_LOADED) {
				if (self->state == 1) {
					double duration;
					gboolean networking;
					int64_t count;
					mpv_get_property(self->mpv, "track-list/count", MPV_FORMAT_INT64, &count);
					FlValue* tracks = fl_value_new_map();
					for (uint i = 0; i < count; i++) {
						FlValue* info = fl_value_new_map();
						gchar* str;
						gchar p[33];
						sprintf(p, "track-list/%d/type", i);
						mpv_get_property(self->mpv, p, MPV_FORMAT_STRING, &str);
						fl_value_set_string_take(info, "type", fl_value_new_string(str));
						uint8_t type = g_str_equal(str, "video") ? 0 : g_str_equal(str, "audio") ? 1 : 2;
						mpv_free(str);
						int64_t trackId;
						sprintf(p, "track-list/%d/id", i);
						mpv_get_property(self->mpv, p, MPV_FORMAT_INT64, &trackId);
						int64_t size;
						sprintf(p, "track-list/%d/lang", i);
						if (!mpv_get_property(self->mpv, p, MPV_FORMAT_STRING, &str)) {
							UErrorCode status = U_ZERO_ERROR;
							char langtag[ULOC_FULLNAME_CAPACITY];
							uloc_toLanguageTag(str, langtag, ULOC_FULLNAME_CAPACITY, FALSE, &status); // we don't want ISO 639-2 codes
							fl_value_set_string_take(info, "language", fl_value_new_string(U_FAILURE(status) ? str : langtag));
							mpv_free(str);
						}
						sprintf(p, "track-list/%d/title", i);
						if (!mpv_get_property(self->mpv, p, MPV_FORMAT_STRING, &str)) {
							fl_value_set_string_take(info, "label", fl_value_new_string(str));
							mpv_free(str);
						}
						sprintf(p, "track-list/%d/hls-bitrate", i);
						if (!mpv_get_property(self->mpv, p, MPV_FORMAT_INT64, &size)) {
							fl_value_set_string_take(info, "bitrate", fl_value_new_int(size));
						} else {
							sprintf(p, "track-list/%d/demux-bitrate", i);
							if (!mpv_get_property(self->mpv, p, MPV_FORMAT_INT64, &size)) {
								fl_value_set_string_take(info, "bitrate", fl_value_new_int(size));
							}
						}
						sprintf(p, "track-list/%d/codec", i);
						if (!mpv_get_property(self->mpv, p, MPV_FORMAT_STRING, &str)) {
							fl_value_set_string_take(info, "format", fl_value_new_string(str));
							mpv_free(str);
						} else {
							sprintf(p, "track-list/%d/format-name", i);
							if (!mpv_get_property(self->mpv, p, MPV_FORMAT_STRING, &str)) {
								fl_value_set_string_take(info, "format", fl_value_new_string(str));
								mpv_free(str);
							}
						}
						if (type == 0) {
							uint16_t data[] = { (uint16_t)trackId, 0, 0 };
							sprintf(p, "track-list/%d/demux-w", i);
							if (!mpv_get_property(self->mpv, p, MPV_FORMAT_INT64, &size)) {
								fl_value_set_string_take(info, "width", fl_value_new_int(size));
								data[1] = (uint16_t)size;
							}
							sprintf(p, "track-list/%d/demux-h", i);
							if (!mpv_get_property(self->mpv, p, MPV_FORMAT_INT64, &size)) {
								fl_value_set_string_take(info, "height", fl_value_new_int(size));
								data[2] = (uint16_t)size;
							}
							g_array_append_val(self->videoTracks, data);
							double fps;
							sprintf(p, "track-list/%d/demux-fps", i);
							if (!mpv_get_property(self->mpv, p, MPV_FORMAT_DOUBLE, &fps)) {
								fl_value_set_string_take(info, "frameRate", fl_value_new_float(fps));
							}
						} else if (type == 1) {
							sprintf(p, "track-list/%d/demux-channel-count", i);
							if (!mpv_get_property(self->mpv, p, MPV_FORMAT_INT64, &size)) {
								fl_value_set_string_take(info, "channels", fl_value_new_int(size));
							}
							sprintf(p, "track-list/%d/demux-samplerate", i);
							if (!mpv_get_property(self->mpv, p, MPV_FORMAT_INT64, &size)) {
								fl_value_set_string_take(info, "sampleRate", fl_value_new_int(size));
							}
						}
						sprintf(p, "%d.%ld", type, trackId);
						fl_value_set_string_take(tracks, p, info);
					}
					mpv_get_property(self->mpv, "duration/full", MPV_FORMAT_DOUBLE, &duration);
					mpv_get_property(self->mpv, "demuxer-via-network", MPV_FORMAT_FLAG, &networking);
					mpv_set_property(self->mpv, "volume", MPV_FORMAT_DOUBLE, &self->volume);
					self->streaming = duration == 0;
					self->networking = networking == TRUE;
					self->state = 2;
					av_media_player_set_max_resolution_real(self);
					g_autoptr(FlValue) evt = fl_value_new_map();
					fl_value_set_string_take(evt, "event", fl_value_new_string("mediaInfo"));
					fl_value_set_string_take(evt, "source", fl_value_new_string(self->source));
					fl_value_set_string_take(evt, "duration", fl_value_new_int((int64_t)(duration * 1000)));
					fl_value_set_string_take(evt, "tracks", tracks);
					fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
				}
			} else if (event->event_id == MPV_EVENT_VIDEO_RECONFIG) {
				if (self->state > 1) {
					int64_t tmp;
					mpv_get_property(self->mpv, "dwidth", MPV_FORMAT_INT64, &tmp);
					self->width = (GLsizei)tmp;
					mpv_get_property(self->mpv, "dheight", MPV_FORMAT_INT64, &tmp);
					self->height = (GLsizei)tmp;
					g_autoptr(FlValue) evt = fl_value_new_map();
					fl_value_set_string_take(evt, "event", fl_value_new_string("videoSize"));
					fl_value_set_string_take(evt, "width", fl_value_new_float(self->width));
					fl_value_set_string_take(evt, "height", fl_value_new_float(self->height));
					fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
				}
			} else if (event->event_id == MPV_EVENT_PLAYBACK_RESTART) {
				if (self->state > 1) {
					g_autoptr(FlValue) evt = fl_value_new_map();
					fl_value_set_string_take(evt, "event", fl_value_new_string("seekEnd"));
					fl_event_channel_send(self->eventChannel, evt, NULL, NULL);
				}
			}
		}
	}
	return FALSE;
}

static void wakeup_callback(void* id) {
	// make sure event_callback is called in the main thread
	g_idle_add(event_callback, id);
}

static void texture_update_callback(void* id) {
	// this function is not called in the main thread
	g_mutex_lock(&plugin->mutex);
	AvMediaPlayer* self = g_tree_lookup(plugin->players, id);
	g_mutex_unlock(&plugin->mutex);
	if (self) {
		fl_texture_registrar_mark_texture_frame_available(self->textureRegistrar, FL_TEXTURE(self));
	}
}

static gboolean av_media_player_texture_populate(FlTextureGL* texture, uint32_t* target, uint32_t* name, uint32_t* width, uint32_t* height, GError** error) {
	AvMediaPlayer* self = AV_MEDIA_PLAYER(texture);
	if (self->state > 0 && self->width > 0 && self->height > 0) {
		if (self->texture == 0 || self->width != self->fbo.w || self->height != self->fbo.h) {
			if (self->texture) {
				glDeleteTextures(1, &self->texture);
			}
			if (self->fbo.fbo) {
				glDeleteFramebuffers(1, (GLuint*)&self->fbo.fbo);
			}
			glGenFramebuffers(1, (GLuint*)&self->fbo.fbo);
			glBindFramebuffer(GL_FRAMEBUFFER, self->fbo.fbo);
			glGenTextures(1, &self->texture);
			glBindTexture(GL_TEXTURE_2D, self->texture);
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, self->width, self->height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0 + 0, GL_TEXTURE_2D, self->texture, 0);
			if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
				return FALSE;
			}
			self->fbo.w = self->width;
			self->fbo.h = self->height;
		}
		mpv_render_param params[] = {
			{MPV_RENDER_PARAM_OPENGL_FBO, &self->fbo},
			{MPV_RENDER_PARAM_INVALID, NULL},
		};
		mpv_render_context_render(self->mpvRenderContext, params);
		*target = GL_TEXTURE_2D;
		*name = self->texture;
		*width = self->width;
		*height = self->height;
		return TRUE;
	}
	return FALSE;
}

static void av_media_player_dispose(GObject* obj) {
	AvMediaPlayer* self = AV_MEDIA_PLAYER(obj);
	g_idle_remove_by_data(self);
	fl_event_channel_send_end_of_stream(self->eventChannel, NULL, NULL);
	mpv_render_context_free(self->mpvRenderContext);
	mpv_destroy(self->mpv);
	g_free(self->source);
	g_array_free(self->videoTracks, TRUE);
	fl_texture_registrar_unregister_texture(self->textureRegistrar, FL_TEXTURE(self));
	if (self->texture) {
		glDeleteTextures(1, &self->texture);
		self->texture = 0;
	}
	if (self->fbo.fbo) {
		glDeleteFramebuffers(1, (GLuint*)&self->fbo.fbo);
		self->fbo.fbo = 0;
	}
	G_OBJECT_CLASS(av_media_player_parent_class)->dispose(obj);
}

static void av_media_player_class_init(AvMediaPlayerClass* klass) {
	FL_TEXTURE_GL_CLASS(klass)->populate = av_media_player_texture_populate;
	G_OBJECT_CLASS(klass)->dispose = av_media_player_dispose;
}

static void av_media_player_init(AvMediaPlayer* self) {
	self->texture = 0;
	self->width = 0;
	self->height = 0;
	self->fbo.fbo = 0;
	self->fbo.w = 0;
	self->fbo.h = 0;
	self->fbo.internal_format = GL_RGBA8;
	self->speed = 1;
	self->looping = false;
	self->state = 0;
	self->position = 0;
	self->bufferPosition = 0;
	self->source = NULL;
	self->streaming = false;
	self->networking = false;
	self->mpv = mpv_create();
	self->videoTracks = g_array_new(FALSE, FALSE, sizeof(uint16_t) * 3);
	av_media_player_set_volume(self, 1);
	//mpv_set_option_string(self->mpv, "terminal", "yes");
	//mpv_set_option_string(self->mpv, "msg-level", "all=v");
	mpv_set_property_string(self->mpv, "vo", "libmpv");
	mpv_set_property_string(self->mpv, "hwdec", "auto-safe");
	mpv_set_property_string(self->mpv, "keep-open", "yes");
	mpv_set_property_string(self->mpv, "idle", "yes");
	//mpv_set_property_string(self->mpv, "sub-create-cc-track", "yes");
	mpv_set_property_string(self->mpv, "cache", "no");
	av_media_player_set_show_subtitle(self, false);
	mpv_initialize(self->mpv);
	mpv_observe_property(self->mpv, 0, "time-pos/full", MPV_FORMAT_DOUBLE);
	mpv_observe_property(self->mpv, 0, "demuxer-cache-time", MPV_FORMAT_DOUBLE);
	mpv_observe_property(self->mpv, 0, "paused-for-cache", MPV_FORMAT_FLAG);
	mpv_observe_property(self->mpv, 0, "pause", MPV_FORMAT_FLAG);
	mpv_opengl_init_params gl_init_params = { gl_init, NULL };
	GdkDisplay* display = gdk_display_get_default();
	if (GDK_IS_WAYLAND_DISPLAY(display)) {
		gl_init_params.get_proc_address_ctx = (void*)2;
	} else if (GDK_IS_X11_DISPLAY(display)) {
		gl_init_params.get_proc_address_ctx = (void*)1;
	}
	mpv_render_param params[] = {
		{MPV_RENDER_PARAM_API_TYPE, MPV_RENDER_API_TYPE_OPENGL},
		{MPV_RENDER_PARAM_OPENGL_INIT_PARAMS, &gl_init_params},
		{MPV_RENDER_PARAM_INVALID, NULL}
	};
	mpv_render_context_create(&self->mpvRenderContext, self->mpv, params);
}

static AvMediaPlayer* av_media_player_new(FlMethodCodec* codec, FlBinaryMessenger* messenger, FlTextureRegistrar* textureRegistrar) {
	AvMediaPlayer* self = AV_MEDIA_PLAYER(g_object_new(av_media_player_get_type(), NULL));
	FlTexture* texture = FL_TEXTURE(self);
	self->textureRegistrar = textureRegistrar;
	fl_texture_registrar_register_texture(self->textureRegistrar, texture);
	self->id = fl_texture_get_id(texture);
	gchar* name = g_strdup_printf("av_media_player/%ld", self->id);
	self->eventChannel = fl_event_channel_new(messenger, name, codec);
	g_free(name);
	mpv_set_wakeup_callback(self->mpv, wakeup_callback, (gpointer)self->id);
	mpv_render_context_set_update_callback(self->mpvRenderContext, texture_update_callback, (gpointer)self->id);
	return self;
}

/* plugin implementation */
static void av_media_player_plugin_clear(AvMediaPlayerPlugin* self) {
	g_mutex_lock(&self->mutex);
	g_tree_foreach(self->players, release_object_on_tree, NULL);
	g_tree_remove_all(self->players);
	g_mutex_unlock(&self->mutex);
}

static void av_media_player_plugin_dispose(GObject* object) {
	G_OBJECT_CLASS(av_media_player_plugin_parent_class)->dispose(object);
	AvMediaPlayerPlugin* self = AV_MEDIA_PLAYER_PLUGIN(object);
	av_media_player_plugin_clear(self);
	g_object_unref(self->methodChannel);
	g_object_unref(self->codec);
	g_tree_destroy(self->players);
}

static void av_media_player_plugin_class_init(AvMediaPlayerPluginClass* klass) {
	G_OBJECT_CLASS(klass)->dispose = av_media_player_plugin_dispose;
}

static void av_media_player_plugin_init(AvMediaPlayerPlugin* self) {
	self->codec = FL_METHOD_CODEC(fl_standard_method_codec_new());
	self->players = g_tree_new(compare_key);
	g_mutex_init(&self->mutex);
	printf("mutex init: %p\n", &self->mutex);
}

static void av_media_player_plugin_method_call(FlMethodChannel* channel, FlMethodCall* method_call, gpointer user_data) {
	AvMediaPlayerPlugin* self = AV_MEDIA_PLAYER_PLUGIN(user_data);
	const gchar* method = fl_method_call_get_name(method_call);
	FlValue* args = fl_method_call_get_args(method_call);
	g_autoptr(FlMethodResponse) response = NULL;
	if (strcmp(method, "create") == 0) {
		AvMediaPlayer* player = av_media_player_new(self->codec, self->messenger, self->textureRegistrar);
		g_mutex_lock(&self->mutex);
		g_tree_insert(self->players, (gpointer)player->id, player);
		g_mutex_unlock(&self->mutex);
		g_autoptr(FlValue) result = fl_value_new_map();
		fl_value_set_string_take(result, "id", fl_value_new_int(player->id));
		response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
	} else if (strcmp(method, "dispose") == 0) {
		if (fl_value_get_type(args) == FL_VALUE_TYPE_NULL) {
			av_media_player_plugin_clear(self);
		} else {
			gpointer id = (gpointer)fl_value_get_int(args);
			g_mutex_lock(&self->mutex);
			g_object_unref(g_tree_lookup(self->players, id));
			g_tree_remove(self->players, id);
			g_mutex_unlock(&self->mutex);
		}
	} else if (strcmp(method, "open") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const gchar* value = fl_value_get_string(fl_value_lookup_string(args, "value"));
		av_media_player_open(player, value);
	} else if (strcmp(method, "close") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(args));
		av_media_player_close(player);
	} else if (strcmp(method, "play") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(args));
		av_media_player_play(player);
	} else if (strcmp(method, "pause") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(args));
		av_media_player_pause(player);
	} else if (strcmp(method, "seekTo") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const int64_t value = fl_value_get_int(fl_value_lookup_string(args, "value"));
		av_media_player_seek_to(player, value);
	} else if (strcmp(method, "setVolume") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const double value = fl_value_get_float(fl_value_lookup_string(args, "value"));
		av_media_player_set_volume(player, value);
	} else if (strcmp(method, "setSpeed") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const double value = fl_value_get_float(fl_value_lookup_string(args, "value"));
		av_media_player_set_speed(player, value);
	} else if (strcmp(method, "setLooping") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const bool value = fl_value_get_bool(fl_value_lookup_string(args, "value"));
		av_media_player_set_looping(player, value);
	} else if (strcmp(method, "setShowSubtitle") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const bool value = fl_value_get_bool(fl_value_lookup_string(args, "value"));
		av_media_player_set_show_subtitle(player, value);
	} else if (strcmp(method, "setPreferredAudioLanguage") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const gchar* value = fl_value_get_string(fl_value_lookup_string(args, "value"));
		av_media_player_set_preferred_audio_language(player, value);
	} else if (strcmp(method, "setPreferredSubtitleLanguage") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const gchar* value = fl_value_get_string(fl_value_lookup_string(args, "value"));
		av_media_player_set_preferred_subtitle_language(player, value);
	} else if (strcmp(method, "setMaxBitRate") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const uint32_t value = (uint32_t)fl_value_get_int(fl_value_lookup_string(args, "value"));
		av_media_player_set_max_bitrate(player, value);
	} else if (strcmp(method, "setMaxResolution") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const uint16_t width = (uint16_t)fl_value_get_float(fl_value_lookup_string(args, "width"));
		const uint16_t height = (uint16_t)fl_value_get_float(fl_value_lookup_string(args, "height"));
		av_media_player_set_max_resolution(player, width, height);
	} else if (strcmp(method, "overrideTrack") == 0) {
		AvMediaPlayer* player = (AvMediaPlayer*)g_tree_lookup(self->players, (gpointer)fl_value_get_int(fl_value_lookup_string(args, "id")));
		const uint8_t typeId = (uint8_t)fl_value_get_int(fl_value_lookup_string(args, "groupId"));
		uint16_t trackId = (uint16_t)fl_value_get_int(fl_value_lookup_string(args, "trackId"));
		const bool enabled = fl_value_get_bool(fl_value_lookup_string(args, "value"));
		av_media_player_overrideTrack(player, typeId, trackId, enabled);
	} else {
		response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
	}
	if (!response) {
		g_autoptr(FlValue) result = fl_value_new_null();
		response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
	}
	fl_method_call_respond(method_call, response, NULL);
}

/* plugin registration */
void av_media_player_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
	setlocale(LC_NUMERIC, "C");
	plugin = AV_MEDIA_PLAYER_PLUGIN(g_object_new(av_media_player_plugin_get_type(), NULL));
	plugin->messenger = fl_plugin_registrar_get_messenger(registrar);
	plugin->textureRegistrar = fl_plugin_registrar_get_texture_registrar(registrar);
	plugin->methodChannel = fl_method_channel_new(plugin->messenger, "av_media_player", plugin->codec);
	fl_method_channel_set_method_call_handler(plugin->methodChannel, av_media_player_plugin_method_call, plugin, g_object_unref);
}