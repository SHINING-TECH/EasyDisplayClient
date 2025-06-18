import 'package:flutter/widgets.dart';
import 'player.dart';
import 'utils.dart';

/// This type is used by [AvMediaView], for sizing the video.
enum SizingMode { free, keepAspectRatio, originalSize }

/// The widget to display video for [AvMediaPlayer].
class AvMediaView extends StatefulWidget {
  final AvMediaPlayer? initPlayer;
  final void Function(AvMediaPlayer player)? onCreated;
  final Color? backgroundColor;
  final SizingMode sizingMode;
  final String? initSource;
  final bool? initAutoPlay;
  final bool? initLooping;
  final double? initVolume;
  final double? initSpeed;
  final int? initPosition;
  final bool? initShowSubtitle;
  final String? initPreferredSubtitleLanguage;
  final String? initPreferredAudioLanguage;
  final int? initMaxBitRate;
  final Size? initMaxResolution;

  /// Create a new [AvMediaView] widget.
  /// If [initPlayer] is null, a new player will be created.
  /// You can get the player from [onCreated] callback.
  ///
  /// [backgroundColor] is the color to display when there is no video.
  /// This parameter can be changed by updating the widget.
  ///
  /// [sizingMode] indicates how to size the video.
  /// This parameter can be changed by updating the widget.
  ///
  /// Other parameters only take efferts at the time the widget is mounted.
  /// To changed them later, you need to call the corresponding methods of the player.
  const AvMediaView({
    super.key,
    this.initPlayer,
    this.initSource,
    this.initAutoPlay,
    this.initLooping,
    this.initVolume,
    this.initSpeed,
    this.initPosition,
    this.initShowSubtitle,
    this.initPreferredSubtitleLanguage,
    this.initPreferredAudioLanguage,
    this.initMaxBitRate,
    this.initMaxResolution,
    this.onCreated,
    this.backgroundColor,
    this.sizingMode = SizingMode.keepAspectRatio,
  });

  @override
  State<AvMediaView> createState() => _AVMediaState();
}

class _AVMediaState extends State<AvMediaView> with SetStateAsync {
  bool _foreignPlayer = false;
  AvMediaPlayer? _player;

  void _update() => setState(() {});

  @override
  void initState() {
    super.initState();
    if (widget.initPlayer == null || widget.initPlayer!.disposed) {
      _player = AvMediaPlayer(
        initSource: widget.initSource,
        initAutoPlay: widget.initAutoPlay,
        initLooping: widget.initLooping,
        initVolume: widget.initVolume,
        initSpeed: widget.initSpeed,
        initPosition: widget.initPosition,
        initShowSubtitle: widget.initShowSubtitle,
        initPreferredSubtitleLanguage: widget.initPreferredSubtitleLanguage,
        initPreferredAudioLanguage: widget.initPreferredAudioLanguage,
        initMaxBitRate: widget.initMaxBitRate,
        initMaxResolution: widget.initMaxResolution,
      );
    } else {
      _player = widget.initPlayer!;
      _foreignPlayer = true;
      if (widget.initSource != null) {
        _player!.open(widget.initSource!);
      }
      if (widget.initAutoPlay != null) {
        _player!.setAutoPlay(widget.initAutoPlay!);
      }
      if (widget.initLooping != null) {
        _player!.setLooping(widget.initLooping!);
      }
      if (widget.initVolume != null) {
        _player!.setVolume(widget.initVolume!);
      }
      if (widget.initSpeed != null) {
        _player!.setSpeed(widget.initSpeed!);
      }
      if (widget.initPosition != null) {
        _player!.seekTo(widget.initPosition!);
      }
      if (widget.initShowSubtitle != null) {
        _player!.setShowSubtitle(widget.initShowSubtitle!);
      }
      if (widget.initPreferredSubtitleLanguage != null) {
        _player!.setPreferredSubtitleLanguage(
            widget.initPreferredSubtitleLanguage!);
      }
      if (widget.initPreferredAudioLanguage != null) {
        _player!.setPreferredAudioLanguage(widget.initPreferredAudioLanguage!);
      }
      if (widget.initMaxBitRate != null) {
        _player!.setMaxBitRate(widget.initMaxBitRate!);
      }
      if (widget.initMaxResolution != null) {
        _player!.setMaxResolution(widget.initMaxResolution!);
      }
    }
    if (widget.onCreated != null) {
      widget.onCreated!(_player!);
    }
    _player!.videoSize.addListener(_update);
    _player!.showSubtitle.addListener(_update);
  }

  @override
  void didUpdateWidget(AvMediaView oldWidget) {
    // if (widget.sizingMode != oldWidget.sizingMode ||
    //     widget.backgroundColor != oldWidget.backgroundColor) {
    //   super.didUpdateWidget(oldWidget);
    // }
    super.didUpdateWidget(oldWidget);
    if (widget.initSource != oldWidget.initSource && _player != null) {
      print('尝试打开新的视频源: ${widget.initSource}');
      _player!.open(widget.initSource!);
      if (widget.initAutoPlay == true) {
        _player!.play();
      }
    }
  }

  @override
  void dispose() {
    if (!_foreignPlayer) {
      _player?.dispose();
    } else if (!_player!.disposed) {
      _player?.videoSize.removeListener(_update);
      _player?.showSubtitle.removeListener(_update);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_player!.videoSize.value != Size.zero) {
      final texture = _player!.subId != null && _player!.showSubtitle.value
          ? Stack(
              textDirection: TextDirection.ltr,
              fit: StackFit.passthrough,
              children: [
                Texture(textureId: _player!.id.value!),
                Texture(textureId: _player!.subId!),
              ],
            )
          : Texture(textureId: _player!.id.value!);
      if (widget.sizingMode == SizingMode.keepAspectRatio) {
        return AspectRatio(
          aspectRatio:
              _player!.videoSize.value.width / _player!.videoSize.value.height,
          child: texture,
        );
      } else if (widget.sizingMode == SizingMode.originalSize) {
        return SizedBox(
          width: _player!.videoSize.value.width,
          height: _player!.videoSize.value.height,
          child: texture,
        );
      } else {
        return texture;
      }
    } else {
      return Container(color: widget.backgroundColor);
    }
  }
}
