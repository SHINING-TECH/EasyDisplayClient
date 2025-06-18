package dev.xx.av_media_player

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.SurfaceTexture
import android.media.MediaFormat
import android.opengl.EGL14
import android.opengl.EGLConfig
import android.opengl.EGLContext
import android.opengl.EGLDisplay
import android.opengl.EGLSurface
import android.opengl.GLES11Ext
import android.opengl.GLES20
import android.os.Handler
import android.os.Looper
import android.view.PixelCopy
import android.view.Surface
import androidx.media3.common.C
import androidx.media3.common.ColorInfo
import androidx.media3.common.Format
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.TrackSelectionOverride
import androidx.media3.common.text.CueGroup
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.video.VideoFrameMetadataListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry.SurfaceProducer
import java.util.concurrent.atomic.AtomicInteger
import kotlin.math.roundToInt

@UnstableApi
class AvMediaPlayer(private val binding: FlutterPlugin.FlutterPluginBinding) : EventChannel.StreamHandler, Player.Listener, VideoFrameMetadataListener, SurfaceProducer.Callback {
	companion object {
		private val trackTypes = mapOf(
			C.TRACK_TYPE_VIDEO to "video",
			C.TRACK_TYPE_AUDIO to "audio",
			C.TRACK_TYPE_TEXT to "sub"
		)
	}
	private val surfaceProducer = binding.textureRegistry.createSurfaceProducer()
	val id = surfaceProducer.id().toInt()
	private val exoPlayer = ExoPlayer.Builder(binding.applicationContext).build()
	private val handler = Handler(exoPlayer.applicationLooper)
	private val glHandler = Handler(exoPlayer.playbackLooper)
	private val eventChannel = EventChannel(binding.binaryMessenger, "av_media_player/$id")
	private val subtitlePainter = SubtitlePainter(binding.applicationContext)
	private val paint = Paint()
	private val copying = AtomicInteger(0) // 0: no, 1: copying, 2: need recycle

	private var videoFrame: Bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
	private var subTitleFrame: Bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
	private var eglSurface: EGLSurface? = null
	private var eglDisplay: EGLDisplay? = null
	private var eglContext: EGLContext? = null
	private var surfaceTexture: SurfaceTexture? = null
	private var surface: Surface? = null
	private var speed = 1F
	private var volume = 1F
	private var looping = false
	private var position = 0L
	private var eventSink: EventChannel.EventSink? = null
	private var watching = false
	private var buffering = false
	private var bufferPosition = 0L
	private var state: UByte = 0U // 0: idle, 1: opening, 2: ready, 3: playing
	private var source: String? = null
	private var seeking = false
	private var networking = false
	private var showSubtitle = false
	private var hidden = false
	private var width = 0
	private var height = 0

	init {
		binding.textureRegistry.createSurfaceProducer()
		eventChannel.setStreamHandler(this)
		exoPlayer.addListener(this)
		exoPlayer.setVideoFrameMetadataListener(this)
		paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_OVER)
		surfaceProducer.setCallback(this)
		// the flutter team refused to provide notification before the surface is destroyed
		// so we have to use a workaround to proxy the surface texture
		// which may increase memory usage and decrease rendering performance
		// https://github.com/flutter/flutter/issues/152839
		glHandler.post {
			eglDisplay = EGL14.eglGetDisplay(EGL14.EGL_DEFAULT_DISPLAY)
			val version = IntArray(2)
			EGL14.eglInitialize(eglDisplay, version, 0, version, 1)
			val configs = arrayOfNulls<EGLConfig>(1)
			val numConfigs = IntArray(1)
			EGL14.eglChooseConfig(eglDisplay, intArrayOf(
				EGL14.EGL_RENDERABLE_TYPE, EGL14.EGL_OPENGL_ES2_BIT,
				EGL14.EGL_RED_SIZE, 8,
				EGL14.EGL_GREEN_SIZE, 8,
				EGL14.EGL_BLUE_SIZE, 8,
				EGL14.EGL_ALPHA_SIZE, 8,
				EGL14.EGL_DEPTH_SIZE, 16,
				EGL14.EGL_STENCIL_SIZE, 8,
				EGL14.EGL_NONE
			), 0, configs, 0, configs.size, numConfigs, 0)
			eglContext = EGL14.eglCreateContext(eglDisplay, configs[0], EGL14.EGL_NO_CONTEXT, intArrayOf(
				EGL14.EGL_CONTEXT_CLIENT_VERSION, 2,
				EGL14.EGL_NONE
			), 0)
			eglSurface = EGL14.eglCreatePbufferSurface(eglDisplay, configs[0], intArrayOf(
				EGL14.EGL_NONE
			), 0)
			EGL14.eglMakeCurrent(eglDisplay, eglSurface, eglSurface, eglContext)
			val textures = IntArray(1)
			GLES20.glGenTextures(1, textures, 0)
			GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, textures[0])
			surfaceTexture = SurfaceTexture(textures[0])
			surface = Surface(surfaceTexture)
			handler.post {
				exoPlayer.setVideoSurface(surface)
			}
			surfaceTexture!!.setOnFrameAvailableListener {
				surfaceTexture!!.updateTexImage()
				if (state > 0U && copying.compareAndSet(0, 1)) { // skip frame if copying
					val old = videoFrame
					PixelCopy.request(surface!!, old, { copyResult ->
						if (copyResult == PixelCopy.SUCCESS && state > 0u && !hidden) {
							render(old)
						}
						if (copying.getAndSet(0) == 2) { // check if just skipped recycle
							old.recycle()
						}
					}, glHandler)
				}
			}
		}
	}

	fun dispose() {
		handler.removeCallbacksAndMessages(null)
		if (eglDisplay != null) {
			glHandler.post {
				EGL14.eglDestroySurface(eglDisplay, eglSurface)
				EGL14.eglDestroyContext(eglDisplay, eglContext)
				EGL14.eglTerminate(eglDisplay)
			}
		}
		exoPlayer.release()
		videoFrame.recycle()
		subTitleFrame.recycle()
		surface?.release()
		surfaceTexture?.release()
		eventSink?.endOfStream()
	}

	fun open(source: String): Any? {
		close()
		var url = ""
		if (source.startsWith("asset://")) {
			url = "asset:///${binding.flutterAssets.getAssetFilePathBySubpath(source.substring(8))}"
		} else if (source.startsWith("file://") || !source.contains("://")) {
			url = if (source.startsWith("file://")) source else "file://$source"
		} else {
			url = source
			networking = true
		}
		try {
			exoPlayer.setMediaItem(if (url.contains(".m3u8")) MediaItem.Builder().setMimeType(MimeTypes.APPLICATION_M3U8).setUri(url).build() else MediaItem.fromUri(url))
			exoPlayer.prepare()
			state = 1U
			this.source = source
		} catch (e: Exception) {
			sendEvent(mapOf(
				"event" to "error",
				"value" to e.toString()
			))
		}
		return null
	}

	fun close(): Any? {
		source = null
		seeking = false
		networking = false
		state = 0U
		position = 0
		bufferPosition = 0
		width = 0
		height = 0
		exoPlayer.playWhenReady = false
		exoPlayer.stop()
		exoPlayer.clearMediaItems()
		Canvas(subTitleFrame).drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)
		if (exoPlayer.trackSelectionParameters.overrides.isNotEmpty()) {
			exoPlayer.trackSelectionParameters = exoPlayer.trackSelectionParameters.buildUpon().clearOverrides().build()
		}
		return null
	}

	fun play(): Any? {
		if (state.compareTo(2U) == 0) {
			state = 3U
			justPlay()
			if (exoPlayer.playbackState == Player.STATE_BUFFERING) {
				sendEvent(mapOf(
					"event" to "loading",
					"value" to true
				))
			}
		}
		return null
	}

	fun pause(): Any? {
		if (state > 2U) {
			state = 2U
			exoPlayer.playWhenReady = false
		}
		return null
	}

	fun seekTo(pos: Long): Any? {
		if (exoPlayer.isCurrentMediaItemLive || exoPlayer.currentPosition == pos) {
			sendEvent(mapOf("event" to "seekEnd"))
		} else {
			seeking = true
			exoPlayer.seekTo(pos)
		}
		return null
	}

	fun setVolume(vol: Float): Any? {
		volume = vol
		exoPlayer.volume = vol
		return null
	}

	fun setSpeed(spd: Float): Any? {
		speed = spd
		exoPlayer.playbackParameters = exoPlayer.playbackParameters.withSpeed(speed)
		return null
	}

	fun setLooping(loop: Boolean): Any? {
		looping = loop
		return null
	}

	fun setMaxResolution(width: Int, height: Int): Any? {
		exoPlayer.trackSelectionParameters = exoPlayer.trackSelectionParameters.buildUpon().setMaxVideoSize(width, height).build()
		return null
	}

	fun setMaxBitrate(bitrate: Int): Any? {
		exoPlayer.trackSelectionParameters = exoPlayer.trackSelectionParameters.buildUpon().setMaxVideoBitrate(bitrate).build()
		return null
	}

	fun setPreferredAudioLanguage(language: String): Any? {
		exoPlayer.trackSelectionParameters = exoPlayer.trackSelectionParameters.buildUpon().setPreferredAudioLanguage(if (language.isEmpty()) null else language).build()
		return null
	}

	fun setPreferredSubtitleLanguage(language: String): Any? {
		exoPlayer.trackSelectionParameters = exoPlayer.trackSelectionParameters.buildUpon().setPreferredTextLanguage(if (language.isEmpty()) null else language).build()
		return null
	}

	fun setShowSubtitle(show: Boolean): Any? {
		showSubtitle = show
		if (copying.get() == 0 && state.compareTo(2U) == 0 && !hidden && width > 0 && height > 0) {
			render(videoFrame)
		}
		return null
	}

	fun overrideTrack(groupId: Int, trackId: Int, enabled: Boolean): Any? {
		if (state > 1U) {
			val group = exoPlayer.currentTracks.groups[groupId]
			if (group != null && trackTypes.contains(group.type) && group.isTrackSupported(trackId, false)) {
				if (enabled) {
					exoPlayer.trackSelectionParameters = exoPlayer.trackSelectionParameters.buildUpon().setOverrideForType(TrackSelectionOverride(group.mediaTrackGroup, trackId)).build()
				} else if (exoPlayer.trackSelectionParameters.overrides.contains(group.mediaTrackGroup) && exoPlayer.trackSelectionParameters.overrides[group.mediaTrackGroup]!!.trackIndices.contains(trackId)) {
					exoPlayer.trackSelectionParameters = exoPlayer.trackSelectionParameters.buildUpon().clearOverride(group.mediaTrackGroup).build()
				}
			}
		}
		return null
	}

	private fun seekEnd() {
		seeking = false
		if (!watching) {
			watchPosition()
		}
		eventSink?.success(mapOf("event" to "seekEnd"))
	}

	private fun justPlay() {
		if (exoPlayer.playbackState == Player.STATE_ENDED) {
			exoPlayer.seekTo(0)
		}
		exoPlayer.playWhenReady = true
		if (!watching && !exoPlayer.isCurrentMediaItemLive) {
			startWatcher()
		}
	}

	private fun startBuffering() {
		buffering = true
		handler.postDelayed({
			if (state > 0U && networking && exoPlayer.isLoading && !exoPlayer.isCurrentMediaItemLive) {
				startBuffering()
				watchBuffer()
			} else {
				buffering = false
			}
		}, 100)
	}

	private fun watchBuffer() {
		val bufferPos = exoPlayer.bufferedPosition
		if (bufferPos != bufferPosition && bufferPos > exoPlayer.currentPosition) {
			bufferPosition = bufferPos
			sendEvent(mapOf(
				"event" to "buffer",
				"begin" to exoPlayer.currentPosition,
				"end" to bufferPosition
			))
		}
	}

	private fun startWatcher() {
		watching = true
		handler.postDelayed({
			if (state > 2U && !exoPlayer.isCurrentMediaItemLive) {
				startWatcher()
			} else {
				watching = false
			}
			watchPosition()
		}, 10)
	}

	private fun watchPosition() {
		val pos = exoPlayer.currentPosition
		if (pos != position) {
			position = pos
			sendEvent(mapOf(
				"event" to "position",
				"value" to pos
			))
		}
	}

	private fun sendEvent(event: Map<String, Any?>) {
		if (Looper.myLooper() == exoPlayer.applicationLooper) {
			eventSink?.success(event)
		} else {
			handler.post {
				sendEvent(event)
			}
		}
	}

	private fun render (videoFrame: Bitmap) {
		val canvas = surfaceProducer.surface.lockHardwareCanvas()
		if (canvas != null) {
			canvas.drawBitmap(videoFrame, 0f, 0f, null)
			if (showSubtitle) {
				canvas.drawBitmap(subTitleFrame, 0f, 0f, paint)
			}
			surfaceProducer.surface.unlockCanvasAndPost(canvas)
		}
	}

	override fun onPlayerError(error: PlaybackException) {
		super.onPlayerError(error)
		if (state > 0U) {
			close()
			sendEvent(mapOf(
				"event" to "error",
				"value" to error.errorCodeName
			))
		}
	}

	override fun onPlaybackStateChanged(playbackState: Int) {
		super.onPlaybackStateChanged(playbackState)
		if (seeking && (playbackState == Player.STATE_READY || playbackState == Player.STATE_ENDED)) {
			seekEnd()
		} else if (playbackState == Player.STATE_READY) {
			if (state.compareTo(1U) == 0) {
				state = 2U
				exoPlayer.volume = volume
				val allTracks = mutableMapOf<String, MutableMap<String, Any?>>()
				for (i in 0 until exoPlayer.currentTracks.groups.size) {
					val group = exoPlayer.currentTracks.groups[i]
					if (trackTypes.contains(group.type)) {
						for (j in 0 until group.length) {
							if (group.isTrackSupported(j, false)) {
								val format = group.getTrackFormat(j)
								if (format.roleFlags != C.ROLE_FLAG_TRICK_PLAY) {
									val track = mutableMapOf<String, Any?>(
										"type" to trackTypes[group.type]!!,
										"title" to format.label,
										"language" to format.language,
										"format" to if (format.codecs == null) format.sampleMimeType else format.codecs,
										"bitRate" to if (format.averageBitrate > 0) format.averageBitrate else format.bitrate
									)
									if (group.type == C.TRACK_TYPE_VIDEO) {
										track["width"] = format.width
										track["height"] = format.height
										track["frameRate"] = format.frameRate
										track["isHdr"] = ColorInfo.isTransferHdr(format.colorInfo)
									} else if (group.type == C.TRACK_TYPE_AUDIO) {
										track["channels"] = format.channelCount
										track["sampleRate"] = format.sampleRate
									}
									allTracks["$i.$j"] = track
								}
							}
						}
					}
				}
				sendEvent(mapOf(
					"event" to "mediaInfo",
					"duration" to if (exoPlayer.isCurrentMediaItemLive) 0 else exoPlayer.duration,
					"tracks" to allTracks,
					"source" to source
				))
			} else if (state > 2U) {
				sendEvent(mapOf(
					"event" to "loading",
					"value" to false
				))
			}
		} else if (playbackState == Player.STATE_ENDED) {
			if (state > 1U && !exoPlayer.isCurrentMediaItemLive) {
				sendEvent(mapOf(
					"event" to "position",
					"value" to exoPlayer.duration
				))
			}
			if (state > 2U) {
				if (exoPlayer.isCurrentMediaItemLive) {
					close()
				} else if (looping) {
					justPlay()
				} else {
					state = 2U
				}
				sendEvent(mapOf("event" to "finished"))
			}
		} else if (playbackState == Player.STATE_BUFFERING) {
			if (state > 2U) {
				sendEvent(mapOf(
					"event" to "loading",
					"value" to true
				))
			}
		}
	}

	override fun onIsLoadingChanged(isLoading: Boolean) {
		super.onIsLoadingChanged(isLoading)
		if (networking && !exoPlayer.isCurrentMediaItemLive) {
			if (isLoading) {
				if (!buffering) {
					startBuffering()
				}
			} else if (buffering) {
				buffering = false
				watchBuffer()
			}
		}
	}

	override fun onCues(cueGroup: CueGroup) {
		super.onCues(cueGroup)
		if (state > 0U) {
			val canvas = Canvas(subTitleFrame)
			canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)
			for (cue in cueGroup.cues) {
				subtitlePainter.draw(cue, canvas)
			}
		}
	}

	override fun onVideoFrameAboutToBeRendered(presentationTimeUs: Long, releaseTimeNs: Long, format: Format, mediaFormat: MediaFormat?) {
		if (state > 0U) {
			val w: Int
			val h: Int
			if (format.rotationDegrees % 180 == 0) {
				w = (format.width * format.pixelWidthHeightRatio).roundToInt()
				h = format.height
			} else {
				w = format.height
				h = (format.width * format.pixelWidthHeightRatio).roundToInt()
			}
			if (w > 0 && h > 0 && (w != surfaceProducer.width || h != surfaceProducer.height)) {
				surfaceProducer.setSize(w, h)
				surfaceTexture?.setDefaultBufferSize(w, h)
				var old = subTitleFrame
				subTitleFrame = Bitmap.createScaledBitmap(old, w, h, true)
				old.recycle()
				old = videoFrame
				videoFrame = Bitmap.createScaledBitmap(old, w, h, true)
				if (!copying.compareAndSet(1, 2)) { // don't recycle if copying
					old.recycle()
				}
			}
			if (w != width || h != height) {
				width = w
				height = h
				sendEvent(mapOf(
					"event" to "videoSize",
					"width" to width.toFloat(),
					"height" to height.toFloat()
				))
			}
		}
	}

	override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
		eventSink = events
	}

	override fun onCancel(arguments: Any?) {
		eventSink = null
	}

	override fun onSurfaceAvailable() {
		hidden = false
		render(videoFrame)
	}

	override fun onSurfaceDestroyed() {
		hidden = true
	}
}

@UnstableApi
class AvMediaPlayerPlugin: FlutterPlugin {
	private lateinit var methodChannel: MethodChannel
	private val players = mutableMapOf<Int, AvMediaPlayer>()
	private fun clear() {
		for (player in players.values) {
			player.dispose()
		}
		players.clear()
	}

	override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
		methodChannel = MethodChannel(binding.binaryMessenger, "av_media_player")
		methodChannel.setMethodCallHandler { call, result ->
			when (call.method) {
				"create" -> {
					val player = AvMediaPlayer(binding)
					players[player.id] = player
					result.success(mapOf(
						"id" to player.id
					))
				}
				"dispose" -> {
					val id = call.arguments
					if (id is Int) {
						players[id]?.dispose()
						players.remove(id)
					} else {
						clear()
					}
					result.success(null)
				}
				"open" -> {
					result.success(players[call.argument<Int>("id")!!]?.open(call.argument<String>("value")!!))
				}
				"close" -> {
					result.success(players[call.arguments as Int]?.close())
				}
				"play" -> {
					result.success(players[call.arguments as Int]?.play())
				}
				"pause" -> {
					result.success(players[call.arguments as Int]?.pause())
				}
				"seekTo" -> {
					result.success(players[call.argument<Int>("id")!!]?.seekTo(call.argument<Long>("value")!!))
				}
				"setVolume" -> {
					result.success(players[call.argument<Int>("id")!!]?.setVolume(call.argument<Float>("value")!!))
				}
				"setSpeed" -> {
					result.success(players[call.argument<Int>("id")!!]?.setSpeed(call.argument<Float>("value")!!))
				}
				"setLooping" -> {
					result.success(players[call.argument<Int>("id")!!]?.setLooping(call.argument<Boolean>("value")!!))
				}
				"setMaxResolution" -> {
					result.success(players[call.argument<Int>("id")!!]?.setMaxResolution(call.argument<Int>("width")!!, call.argument<Int>("height")!!))
				}
				"setMaxBitrate" -> {
					result.success(players[call.argument<Int>("id")!!]?.setMaxBitrate(call.argument<Int>("value")!!))
				}
				"setPreferredAudioLanguage" -> {
					result.success(players[call.argument<Int>("id")!!]?.setPreferredAudioLanguage(call.argument<String>("value")!!))
				}
				"setPreferredSubtitleLanguage" -> {
					result.success(players[call.argument<Int>("id")!!]?.setPreferredSubtitleLanguage(call.argument<String>("value")!!))
				}
				"overrideTrack" -> {
					result.success(players[call.argument<Int>("id")!!]?.overrideTrack(call.argument<Int>("groupId")!!, call.argument<Int>("trackId")!!, call.argument<Boolean>("value")!!))
				}
				"setShowSubtitle" -> {
					result.success(players[call.argument<Int>("id")!!]?.setShowSubtitle(call.argument<Boolean>("value")!!))
				}
				else -> {
					result.notImplemented()
				}
			}
		}
	}

	override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
		methodChannel.setMethodCallHandler(null)
		clear()
	}
}