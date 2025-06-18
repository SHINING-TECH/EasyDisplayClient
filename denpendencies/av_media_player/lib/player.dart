import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// This type is used by [AvMediaPlayer] to show the current playback state.
enum PlaybackState { playing, paused, closed }

/// This type is used by [AvMediaPlayer] to show the current buffer status.
class BufferRange {
  static const empty = BufferRange(0, 0);

  final int begin;
  final int end;
  const BufferRange(this.begin, this.end);
}

/// This type is used by [TrackInfo] to show the type of the track.
enum TrackType { audio, video, subtitle }

/// This type is used by [MediaInfo] to show information about a track.
/// Only [type] is guaranteed to be non-null. Other information may not be available and can be different on different platforms.
class TrackInfo {
  static TrackInfo fromMap(Map map) {
    final type = map['type'] as String;
    final format = map['format'] as String?;
    final language = map['language'] as String?;
    final title = map['title'] as String?;
    final bitRate = map['bitRate'] as int?;
    final videoSize = map['width'] == null ||
            map['height'] == null ||
            map['width'] <= 0 ||
            map['height'] <= 0
        ? null
        : Size(map['width'].toDouble(), map['height'].toDouble());
    final frameRate = map['frameRate'] as double?;
    final channels = map['channels'] as int?;
    final sampleRate = map['sampleRate'] as int?;
    final isHdr = map['isHdr'] as bool?;
    return TrackInfo(
      type == 'audio'
          ? TrackType.audio
          : type == 'video'
              ? TrackType.video
              : TrackType.subtitle,
      format: format == "" ? null : format,
      language: language == "" ? null : language,
      title: title == "" ? null : title,
      isHdr: isHdr,
      videoSize: videoSize,
      frameRate: frameRate != null && frameRate > 0 ? frameRate : null,
      bitRate: bitRate != null && bitRate > 0 ? bitRate : null,
      channels: channels != null && channels > 0 ? channels : null,
      sampleRate: sampleRate != null && sampleRate > 0 ? sampleRate : null,
    );
  }

  final TrackType type;
  final String? format;
  final String? language;
  final String? title;
  final int? bitRate;
  final Size? videoSize;
  final double? frameRate;
  final int? channels;
  final int? sampleRate;
  final bool? isHdr;
  const TrackInfo(
    this.type, {
    this.isHdr,
    this.format,
    this.language,
    this.title,
    this.videoSize,
    this.frameRate,
    this.bitRate,
    this.channels,
    this.sampleRate,
  });
}

/// This type is used by [AvMediaPlayer] to show current media info.
/// [duration] == 0 means the media is realtime stream.
/// [tracks] contains all the tracks of the media. The key is the track id. However, video tracks may not available on ios/macos/windows.
class MediaInfo {
  final int duration;
  final Map<String, TrackInfo> tracks;
  final String source;
  const MediaInfo(this.duration, this.tracks, this.source);
}

/// The class to create and control [AvMediaPlayer] instance.
///
/// Do NOT modify properties directly, use the corresponding methods instead.
class AvMediaPlayer {
  static const _methodChannel = MethodChannel('av_media_player');
  static var _detectorStarted = false;

  /// Whether the player is disposed.
  var disposed = false;

  /// The id of the subtitle texture if available.
  /// This value does not change after the player is initialized.
  int? subId;

  /// The id of the player.
  /// It should be unique and never change again after the player is initialized, or null otherwise.
  final id = ValueNotifier<int?>(null);

  /// The information of the current media.
  /// It's null before the media is opened.
  final mediaInfo = ValueNotifier<MediaInfo?>(null);

  /// The size of the current video.
  /// This value is Size.zero by default, and may change during playback.
  final videoSize = ValueNotifier<Size>(Size.zero);

  /// The position of the current media in milliseconds.
  /// It's 0 before the media is opened.
  final position = ValueNotifier(0);

  /// The error message of the player.
  /// It's null before an error occurs.
  final error = ValueNotifier<String?>(null);

  /// The loading state of the player.
  /// It's false before opening a media.
  final loading = ValueNotifier(false);

  /// The playback state of the player.
  /// It's [PlaybackState.closed] berore a media is opened.
  final playbackState = ValueNotifier(PlaybackState.closed);

  /// The volume of the player.
  /// It's between 0 and 1, and defaults to 1.
  final volume = ValueNotifier(1.0);

  /// The speed of the player.
  /// It's between 0.5 and 2, and defaults to 1.
  final speed = ValueNotifier(1.0);

  /// Whether the player should loop the media.
  /// It's false by default.
  final looping = ValueNotifier(false);

  /// Whether the player should play the media automatically.
  /// It's false by default.
  final autoPlay = ValueNotifier(false);

  /// How many times the player has finished playing the current media.
  /// It will be reset to 0 when the media is closed.
  final finishedTimes = ValueNotifier(0);

  /// The current buffer status of the player.
  /// It is only reported by network media.
  final bufferRange = ValueNotifier(BufferRange.empty);

  /// The tracks that are overrided by the player.
  final overrideTracks = ValueNotifier<Set<String>>({});

  /// Current maximum bit rate of the player. 0 means no limit.
  final maxBitRate = ValueNotifier(0);

  /// Current maximum resolution of the player. [Size.zero] means no limit.
  final maxResolution = ValueNotifier(Size.zero);

  /// The preferred audio language of the player.
  final preferredAudioLanguage = ValueNotifier<String>('');

  /// The preferred subtitle language of the player.
  final preferredSubtitleLanguage = ValueNotifier<String>('');

  /// Whether to show subtitles.
  /// By default, the player does not show any subtitle. Regardless of the preferred subtitle language or override tracks.
  final showSubtitle = ValueNotifier(false);

  // Event channel is much more efficient than method channel
  // We'd better use it to handle playback events especially for position
  StreamSubscription? _eventSubscription;
  String? _source;
  int? _position;
  var _seeking = false;

  /// All parameters are optional, and can be changed later by calling the corresponding methods.
  AvMediaPlayer({
    String? initSource,
    double? initVolume,
    double? initSpeed,
    bool? initLooping,
    bool? initAutoPlay,
    int? initPosition,
    bool? initShowSubtitle,
    String? initPreferredSubtitleLanguage,
    String? initPreferredAudioLanguage,
    int? initMaxBitRate,
    Size? initMaxResolution,
  }) {
    if (kDebugMode && !_detectorStarted) {
      _detectorStarted = true;
      final receivePort = ReceivePort();
      receivePort.listen((_) => _methodChannel.invokeMethod('dispose'));
      Isolate.spawn(
        (_) {},
        null,
        paused: true,
        onExit: receivePort.sendPort,
        debugName: 'AvMediaPlayer restart detector',
      );
    }
    _methodChannel.invokeMethod('create').then((value) {
      if (disposed) {
        _methodChannel.invokeMethod('dispose', value['id']);
      } else {
        subId = value['subId'];
        id.value = value['id'];
        _eventSubscription = EventChannel('av_media_player/${id.value}')
            .receiveBroadcastStream()
            .listen((event) {
          final e = event as Map;
          if (e['event'] == 'mediaInfo') {
            if (_source == e['source']) {
              loading.value = false;
              playbackState.value = PlaybackState.paused;
              mediaInfo.value = MediaInfo(
                  e['duration'],
                  (e['tracks'] as Map).map(
                      (k, v) => MapEntry(k as String, TrackInfo.fromMap(v))),
                  _source!);
              if (autoPlay.value) {
                play();
              }
              if (_position != null) {
                seekTo(_position!);
                _position = null;
              }
            }
          } else if (e['event'] == 'videoSize') {
            if (playbackState.value != PlaybackState.closed || loading.value) {
              final width = e['width'] as double;
              final height = e['height'] as double;
              if (width != videoSize.value.width ||
                  height != videoSize.value.height) {
                videoSize.value = width > 0 && height > 0
                    ? Size(e['width'], e['height'])
                    : Size.zero;
              }
            }
          } else if (e['event'] == 'playbackState') {
            playbackState.value = e['value'] == 'playing'
                ? PlaybackState.playing
                : e['value'] == 'paused'
                    ? PlaybackState.paused
                    : PlaybackState.closed;
          } else if (e['event'] == 'position') {
            if (mediaInfo.value != null) {
              position.value = e['value'] > mediaInfo.value!.duration
                  ? mediaInfo.value!.duration
                  : e['value'] < 0
                      ? 0
                      : e['value'];
            }
          } else if (e['event'] == 'buffer') {
            if (mediaInfo.value != null) {
              final begin = e['begin'] as int;
              final end = e['end'] as int;
              bufferRange.value = begin == 0 && end == 0
                  ? BufferRange.empty
                  : BufferRange(begin, end);
            }
          } else if (e['event'] == 'error') {
            // ignore errors when player is closed
            if (playbackState.value != PlaybackState.closed || loading.value) {
              _source = null;
              error.value = e['value'];
              loading.value = false;
              _close();
            }
          } else if (e['event'] == 'loading') {
            if (mediaInfo.value != null) {
              loading.value = e['value'];
            }
          } else if (e['event'] == 'seekEnd') {
            if (mediaInfo.value != null) {
              _seeking = false;
              loading.value = false;
            }
          } else if (e['event'] == 'finished') {
            if (mediaInfo.value != null) {
              if (!looping.value && mediaInfo.value!.duration != 0) {
                playbackState.value = PlaybackState.paused;
              }
              finishedTimes.value += 1;
              if (mediaInfo.value!.duration == 0) {
                playbackState.value = PlaybackState.closed;
              }
            }
          }
        });
        if (_source != null) {
          open(_source!);
        }
        if (volume.value != 1) {
          _setVolume();
        }
        if (speed.value != 1) {
          _setSpeed();
        }
        if (looping.value) {
          _setLooping();
        }
        if (maxBitRate.value > 0) {
          _setMaxBitRate();
        }
        if (maxResolution.value != Size.zero) {
          _setMaxResolution();
        }
        if (preferredAudioLanguage.value.isNotEmpty) {
          _setPreferredAudioLanguage();
        }
        if (preferredSubtitleLanguage.value.isNotEmpty) {
          _setPreferredSubtitleLanguage();
        }
        if (showSubtitle.value) {
          _setShowSubtitle();
        }
      }
    });
    _position = initPosition;
    if (initSource != null) {
      open(initSource);
    }
    if (initVolume != null) {
      setVolume(initVolume);
    }
    if (initSpeed != null) {
      setSpeed(initSpeed);
    }
    if (initLooping != null) {
      setLooping(initLooping);
    }
    if (initAutoPlay != null) {
      setAutoPlay(initAutoPlay);
    }
    if (initMaxBitRate != null) {
      setMaxBitRate(initMaxBitRate);
    }
    if (initMaxResolution != null) {
      setMaxResolution(initMaxResolution);
    }
    if (initPreferredAudioLanguage != null) {
      setPreferredAudioLanguage(initPreferredAudioLanguage);
    }
    if (initPreferredSubtitleLanguage != null) {
      setPreferredSubtitleLanguage(initPreferredSubtitleLanguage);
    }
    if (initShowSubtitle != null) {
      setShowSubtitle(initShowSubtitle);
    }
  }

  /// Dispose the player.
  void dispose() {
    if (!disposed) {
      disposed = true;
      _eventSubscription?.cancel();
      if (id.value != null) {
        _methodChannel.invokeMethod('dispose', id.value);
      }
      id.dispose();
      mediaInfo.dispose();
      videoSize.dispose();
      position.dispose();
      error.dispose();
      loading.dispose();
      playbackState.dispose();
      volume.dispose();
      speed.dispose();
      looping.dispose();
      autoPlay.dispose();
      finishedTimes.dispose();
      bufferRange.dispose();
      overrideTracks.dispose();
      maxBitRate.dispose();
      maxResolution.dispose();
      preferredAudioLanguage.dispose();
      preferredSubtitleLanguage.dispose();
      showSubtitle.dispose();
    }
  }

  /// Open a media file.
  ///
  /// [source] is the url or local path of the media file
  void open(String source) {
    if (!disposed) {
      _source = source;
      if (id.value != null) {
        error.value = null;
        _close();
        _methodChannel.invokeMethod('open', {
          'id': id.value,
          'value': source,
        });
      }
      loading.value = true;
    }
  }

  /// Close or stop opening the media file.
  void close() {
    if (!disposed) {
      _source = null;
      if (id.value != null &&
          (playbackState.value != PlaybackState.closed || loading.value)) {
        _methodChannel.invokeMethod('close', id.value);
        _close();
      }
      loading.value = false;
    }
  }

  /// Play the current media.
  ///
  /// If the the player is opening a media file, calling this method will set autoplay to true.
  bool play() {
    if (!disposed) {
      if (id.value != null && playbackState.value == PlaybackState.paused) {
        _methodChannel.invokeMethod('play', id.value);
        playbackState.value = PlaybackState.playing;
        return true;
      } else if (!autoPlay.value &&
          playbackState.value == PlaybackState.closed &&
          _source != null) {
        setAutoPlay(true);
        return true;
      }
    }
    return false;
  }

  /// Pause the current media file.
  ///
  /// If the the player is opening a media file, calling this method will set autoplay to false.
  bool pause() {
    if (!disposed) {
      if (id.value != null && playbackState.value == PlaybackState.playing) {
        _methodChannel.invokeMethod('pause', id.value);
        playbackState.value = PlaybackState.paused;
        if (!_seeking) {
          loading.value = false;
        }
        return true;
      } else if (autoPlay.value &&
          playbackState.value == PlaybackState.closed &&
          _source != null) {
        setAutoPlay(false);
        return true;
      }
    }
    return false;
  }

  /// Seek to a specific position.
  ///
  /// [position] is the position to seek to in milliseconds.
  bool seekTo(int position) {
    if (!disposed && id.value != null) {
      if (mediaInfo.value == null) {
        if (loading.value) {
          _position = position;
          return true;
        }
      } else if (mediaInfo.value!.duration > 0) {
        if (position < 0) {
          position = 0;
        } else if (position > mediaInfo.value!.duration) {
          position = mediaInfo.value!.duration;
        }
        _methodChannel.invokeMethod('seekTo', {
          'id': id.value,
          'value': position,
        });
        loading.value = true;
        _seeking = true;
        return true;
      }
    }
    return false;
  }

  /// Set the volume of the player.
  ///
  /// [volume] is the volume to set between 0 and 1.
  bool setVolume(double volume) {
    if (!disposed) {
      if (volume < 0) {
        volume = 0;
      } else if (volume > 1) {
        volume = 1;
      }
      if (this.volume.value != volume) {
        this.volume.value = volume;
        _setVolume();
        return true;
      }
    }
    return false;
  }

  /// Set playback speed of the player.
  ///
  /// [speed] is the speed to set between 0.5 and 2.
  bool setSpeed(double speed) {
    if (!disposed) {
      if (speed < 0.5) {
        speed = 0.5;
      } else if (speed > 2) {
        speed = 2;
      }
      if (this.speed.value != speed) {
        this.speed.value = speed;
        if (id.value != null) {
          _setSpeed();
        }
        return true;
      }
    }
    return false;
  }

  /// Set whether the player should loop the media.
  bool setLooping(bool looping) {
    if (!disposed && looping != this.looping.value) {
      this.looping.value = looping;
      if (id.value != null) {
        _setLooping();
      }
      return true;
    }
    return false;
  }

  /// Set whether the player should play the media automatically.
  bool setAutoPlay(bool autoPlay) {
    if (!disposed && autoPlay != this.autoPlay.value) {
      this.autoPlay.value = autoPlay;
      return true;
    }
    return false;
  }

  /// Set the maximum resolution of the player.
  /// This method may not work on windows.
  bool setMaxResolution(Size resolution) {
    if (!disposed &&
        resolution.width >= 0 &&
        resolution.height >= 0 &&
        (resolution.width != maxResolution.value.width ||
            resolution.height != maxResolution.value.height)) {
      maxResolution.value = resolution;
      if (id.value != null) {
        _setMaxResolution();
      }
      return true;
    }
    return false;
  }

  /// Set the maximum bit rate of the player.
  /// This method may not work on windows.
  bool setMaxBitRate(int bitrate) {
    if (!disposed && bitrate >= 0 && bitrate != maxBitRate.value) {
      maxBitRate.value = bitrate;
      if (id.value != null) {
        _setMaxBitRate();
      }
      return true;
    }
    return false;
  }

  /// Set the preferred audio language of the player.
  /// An empty string means using the system default.
  bool setPreferredAudioLanguage(String language) {
    if (!disposed && language != preferredAudioLanguage.value) {
      preferredAudioLanguage.value = language;
      if (id.value != null) {
        _setPreferredAudioLanguage();
      }
      return true;
    }
    return false;
  }

  /// Set the preferred subtitle language of the player.
  /// An empty string means using the system default.
  bool setPreferredSubtitleLanguage(String language) {
    if (!disposed && language != preferredSubtitleLanguage.value) {
      preferredSubtitleLanguage.value = language;
      if (id.value != null) {
        _setPreferredSubtitleLanguage();
      }
      return true;
    }
    return false;
  }

  /// Set whether to show subtitles.
  bool setShowSubtitle(bool show) {
    if (!disposed && show != showSubtitle.value) {
      showSubtitle.value = show;
      if (id.value != null) {
        _setShowSubtitle();
      }
      return true;
    }
    return false;
  }

  /// Force the player to override a track. Or cancel the override.
  /// [trackId] should be a key of [MediaInfo.tracks].
  bool overrideTrack(String trackId, bool enabled) {
    if (!disposed &&
        mediaInfo.value != null &&
        mediaInfo.value!.tracks.containsKey(trackId) &&
        overrideTracks.value.contains(trackId) != enabled) {
      final ids = trackId.split('.');
      _methodChannel.invokeMethod('overrideTrack', {
        'id': id.value,
        'groupId': int.parse(ids[0]),
        'trackId': int.parse(ids[1]),
        'value': enabled,
      });
      if (enabled) {
        final newTracks = overrideTracks.value.difference(overrideTracks.value
            .where((id) =>
                id != trackId &&
                mediaInfo.value!.tracks[id]!.type ==
                    mediaInfo.value!.tracks[trackId]!.type)
            .toSet());
        newTracks.add(trackId);
        overrideTracks.value = newTracks;
      } else {
        overrideTracks.value = overrideTracks.value.difference({trackId});
      }
      return true;
    }
    return false;
  }

  void _setMaxResolution() => _methodChannel.invokeMethod('setMaxResolution', {
        'id': id.value,
        'width': maxResolution.value.width,
        'height': maxResolution.value.height,
      });

  void _setMaxBitRate() => _methodChannel.invokeMethod('setMaxBitRate', {
        'id': id.value,
        'value': maxBitRate.value,
      });

  void _setVolume() => _methodChannel.invokeMethod('setVolume', {
        'id': id.value,
        'value': volume.value,
      });

  void _setSpeed() => _methodChannel.invokeMethod('setSpeed', {
        'id': id.value,
        'value': speed.value,
      });

  void _setLooping() => _methodChannel.invokeMethod('setLooping', {
        'id': id.value,
        'value': looping.value,
      });

  void _setPreferredAudioLanguage() =>
      _methodChannel.invokeMethod('setPreferredAudioLanguage', {
        'id': id.value,
        'value': preferredAudioLanguage.value,
      });

  void _setPreferredSubtitleLanguage() =>
      _methodChannel.invokeMethod('setPreferredSubtitleLanguage', {
        'id': id.value,
        'value': preferredSubtitleLanguage.value,
      });

  void _setShowSubtitle() => _methodChannel.invokeMethod('setShowSubtitle', {
        'id': id.value,
        'value': showSubtitle.value,
      });

  void _close() {
    mediaInfo.value = null;
    videoSize.value = Size.zero;
    position.value = 0;
    bufferRange.value = BufferRange.empty;
    finishedTimes.value = 0;
    playbackState.value = PlaybackState.closed;
    overrideTracks.value = {};
  }
}
