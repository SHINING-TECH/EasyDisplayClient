// This example shows how to handle playback events and control the player.
// Please note that the SetStateAsync mixin is necessary cause setState() may be called during build process.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_subtitle/flutter_subtitle.dart';
import 'package:av_media_player/index.dart';
import 'sources.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> with SetStateAsync {
  final _player = AvMediaPlayer(initSource: videoSources.first);
  final _httpClient = HttpClient();
  SubtitleController? _subtitleController;

  void _update() => setState(() {});

  @override
  initState() {
    super.initState();
    _player.playbackState.addListener(_update);
    _player.position.addListener(_update);
    _player.speed.addListener(_update);
    _player.volume.addListener(_update);
    _player.mediaInfo.addListener(_update);
    _player.videoSize.addListener(_update);
    _player.loading.addListener(_update);
    _player.looping.addListener(_update);
    _player.autoPlay.addListener(_update);
    _player.error.addListener(() {
      if (_player.error.value != null) {
        debugPrint('Error: ${_player.error.value}');
      }
    });
    _player.bufferRange.addListener(() {
      if (_player.bufferRange.value != BufferRange.empty) {
        debugPrint(
            'position: ${_player.position.value} buffer begin: ${_player.bufferRange.value.begin} buffer end: ${_player.bufferRange.value.end}');
      }
    });
  }

  @override
  void dispose() {
    //We should dispose this player. cause it's managed by the user.
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _player.autoPlay.value,
                        onChanged: (value) =>
                            _player.setAutoPlay(value ?? false),
                      ),
                      const Text('Autoplay'),
                      const Spacer(),
                      Checkbox(
                        value: _player.looping.value,
                        onChanged: (value) =>
                            _player.setLooping(value ?? false),
                      ),
                      const Text('Playback loop'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Open Subtitle',
                      hintText: 'Please input a subtitle URL',
                    ),
                    keyboardType: TextInputType.url,
                    onSubmitted: (value) async {
                      if (value.isNotEmpty && Uri.tryParse(value) != null) {
                        final request =
                            await _httpClient.getUrl(Uri.parse(value));
                        final response = await request.close();
                        final fileContents = await response
                            .transform(const Utf8Decoder())
                            .join();
                        setState(() => _subtitleController =
                            SubtitleController.string(fileContents,
                                format: value.endsWith('.srt')
                                    ? SubtitleFormat.srt
                                    : SubtitleFormat.webvtt));
                      } else {
                        setState(() => _subtitleController = null);
                      }
                    },
                  ),
                  AspectRatio(
                    aspectRatio: _player.videoSize.value == Size.zero
                        ? 16 / 9
                        : _player.videoSize.value.width /
                            _player.videoSize.value.height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AvMediaView(
                          initPlayer: _player,
                          backgroundColor: Colors.black,
                          sizingMode: SizingMode.free,
                        ),
                        if (_player.mediaInfo.value != null &&
                            _player.videoSize.value == Size.zero)
                          const Text(
                            'Audio only',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        if (_subtitleController != null)
                          SubtitleControllView(
                            subtitleController: _subtitleController!,
                            inMilliseconds: _player.position.value,
                          ),
                        if (_player.loading.value)
                          const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                  Slider(
                    // min: 0,
                    max: (_player.mediaInfo.value?.duration ?? 0).toDouble(),
                    value: _player.position.value.toDouble(),
                    onChanged: (value) => _player.seekTo(value.toInt()),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatDuration(
                            Duration(milliseconds: _player.position.value)),
                      ),
                      const Spacer(),
                      Text(_player.error.value ??
                          '${_player.videoSize.value.width.toInt()}x${_player.videoSize.value.height.toInt()}'),
                      const Spacer(),
                      Text(
                        _formatDuration(Duration(
                            milliseconds:
                                _player.mediaInfo.value?.duration ?? 0)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => _player.play(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.pause),
                        onPressed: () => _player.pause(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () => _player.close(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fast_rewind),
                        onPressed: () =>
                            _player.seekTo(_player.position.value - 5000),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fast_forward),
                        onPressed: () =>
                            _player.seekTo(_player.position.value + 5000),
                      ),
                      const Spacer(),
                      Icon(
                        _player.playbackState.value == PlaybackState.playing
                            ? Icons.play_arrow
                            : _player.playbackState.value ==
                                    PlaybackState.paused
                                ? Icons.pause
                                : Icons.stop,
                        size: 16.0,
                        color: const Color(0x80000000),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          'Volume: ${_player.volume.value.toStringAsFixed(2)}'),
                      Expanded(
                        child: Slider(
                          value: _player.volume.value,
                          onChanged: (value) => _player.setVolume(value),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Speed: ${_player.speed.value.toStringAsFixed(2)}'),
                      Expanded(
                        child: Slider(
                          value: _player.speed.value,
                          onChanged: (value) => _player.setSpeed(value),
                          min: 0.5,
                          max: 2,
                          divisions: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: videoSources.length,
                itemBuilder: (context, index) => AspectRatio(
                  aspectRatio: 16 / 9,
                  child: InkWell(
                    onTap: () => _player.open(videoSources[index]),
                    child: AvMediaView(
                      initSource: videoSources[index],
                      backgroundColor: Colors.black,
                      sizingMode: SizingMode.free,
                    ),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );

  String _formatDuration(Duration duration) {
    final hours = duration.inHours > 0 ? '${duration.inHours}:' : '';
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours$minutes:$seconds';
  }
}
