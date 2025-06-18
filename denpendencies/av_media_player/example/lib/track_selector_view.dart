// This example shows how to handle tracks in the player.
import 'package:flutter/material.dart';
import 'package:av_media_player/index.dart';

class TrackSelectorView extends StatefulWidget {
  const TrackSelectorView({super.key});

  @override
  State<TrackSelectorView> createState() => _TrackSelectorViewState();
}

class _TrackSelectorViewState extends State<TrackSelectorView>
    with SetStateAsync {
  final _player = AvMediaPlayer(
      initSource:
          'https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8');
  final _videoTracks = <String>{};
  final _audioTracks = <String>{};
  final _subtitleTracks = <String>{};
  final _inputController = TextEditingController();

  void _update() => setState(() {});

  @override
  initState() {
    super.initState();
    _player.showSubtitle.addListener(_update);
    _player.playbackState.addListener(_update);
    _player.position.addListener(_update);
    _player.overrideTracks.addListener(_update);
    _player.videoSize.addListener(_update);
    _player.loading.addListener(_update);
    _player.mediaInfo.addListener(() => setState(() {
          _videoTracks.clear();
          _audioTracks.clear();
          _subtitleTracks.clear();
          if (_player.mediaInfo.value != null) {
            _inputController.text = _player.mediaInfo.value!.source;
            _player.mediaInfo.value!.tracks.forEach((k, v) {
              if (v.type == TrackType.video) {
                _videoTracks.add(k);
              } else if (v.type == TrackType.audio) {
                _audioTracks.add(k);
              } else if (v.type == TrackType.subtitle) {
                _subtitleTracks.add(k);
              }
            });
          }
        }));
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
                  TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      labelText: 'Open Media',
                      hintText: 'Please input a media URL',
                    ),
                    keyboardType: TextInputType.url,
                    onSubmitted: (value) {
                      if (value.isNotEmpty && Uri.tryParse(value) != null) {
                        _player.open(value);
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  DropdownMenu(
                    width: 150,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "", label: "Auto detect"),
                      DropdownMenuEntry(value: "en", label: "English"),
                      DropdownMenuEntry(value: "it", label: "Italian"),
                    ],
                    label: const Text(
                      "Audio Language",
                      style: TextStyle(fontSize: 14),
                    ),
                    onSelected: (value) =>
                        _player.setPreferredAudioLanguage(value ?? ""),
                  ),
                  DropdownMenu(
                    width: 150,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "", label: "Auto detect"),
                      DropdownMenuEntry(value: "en", label: "English"),
                      DropdownMenuEntry(value: "ja", label: "Japanese"),
                      DropdownMenuEntry(value: "es", label: "Spanish"),
                    ],
                    label: const Text(
                      "Subtitle Language",
                      style: TextStyle(fontSize: 14),
                    ),
                    onSelected: (value) =>
                        _player.setPreferredSubtitleLanguage(value ?? ""),
                  ),
                  DropdownMenu(
                    width: 150,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "0", label: "Unlimited"),
                      DropdownMenuEntry(value: "4194304", label: "4Mbps"),
                      DropdownMenuEntry(value: "2097152", label: "2Mbps"),
                      DropdownMenuEntry(value: "1048576", label: "1Mbps"),
                    ],
                    label: const Text(
                      "Max bitrate",
                      style: TextStyle(fontSize: 14),
                    ),
                    onSelected: (value) =>
                        _player.setMaxBitRate(int.parse(value!)),
                  ),
                  DropdownMenu(
                    width: 150,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "0x0", label: "Unlimited"),
                      DropdownMenuEntry(value: "1920x1080", label: "1080p"),
                      DropdownMenuEntry(value: "1280x720", label: "720p"),
                      DropdownMenuEntry(value: "640x360", label: "360p"),
                    ],
                    label: const Text(
                      "Max Resolution",
                      style: TextStyle(fontSize: 14),
                    ),
                    onSelected: (value) {
                      final parts = value!.split('x');
                      _player.setMaxResolution(Size(
                        double.parse(parts[0]),
                        double.parse(parts[1]),
                      ));
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _player.showSubtitle.value,
                  onChanged: (value) => _player.setShowSubtitle(value ?? false),
                ),
                Text(
                  'Subtitle Tracks: ${_subtitleTracks.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            _buildListView(TrackType.subtitle),
            Text(
              'Audio Tracks: ${_audioTracks.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            _buildListView(TrackType.audio),
            Text(
              'Video Tracks: ${_videoTracks.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            _buildListView(TrackType.video),
          ],
        ),
      );

  Widget _buildListView(TrackType type) {
    final ids = type == TrackType.video
        ? _videoTracks
        : type == TrackType.audio
            ? _audioTracks
            : _subtitleTracks;
    return SizedBox(
      height: type == TrackType.video
          ? 100
          : type == TrackType.audio
              ? 134
              : 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 16),
        itemCount: ids.length,
        itemBuilder: (context, index) {
          final id = ids.elementAt(index);
          final track = _player.mediaInfo.value!.tracks[id]!;
          final selected = _player.overrideTracks.value.contains(id);
          return InkWell(
            onTap: () => _player.overrideTrack(id, !selected),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: selected ? Colors.blue : Colors.blueGrey,
              ),
              padding: const EdgeInsets.all(6),
              alignment: Alignment.center,
              child: Text(
                type == TrackType.video
                    ? '''${track.videoSize != null ? '${track.videoSize!.width.toInt()}x${track.videoSize!.height.toInt()}' : 'unknown size'}
${track.frameRate != null ? '${track.frameRate!.round()}fps' : 'unknown framerate'}
${track.bitRate != null ? _formatBitRate(track.bitRate!) : 'unknown bitrate'}
${track.format ?? 'unknown format'}'''
                    : type == TrackType.audio
                        ? '''${track.title ?? 'unknown title'}
${track.language ?? 'unknown language'}
${track.channels != null ? '${track.channels} channels' : 'unknown channels'}
${track.bitRate != null ? _formatBitRate(track.bitRate!) : 'unknown bitrate'}
${track.sampleRate != null ? '${track.sampleRate!}Hz' : 'unknown sample rate'}
${track.format ?? 'unknown format'}'''
                        : '''${track.title ?? 'unknown title'}
${track.language ?? 'unknown language'}
${track.format ?? 'unknown format'}''',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 8),
      ),
    );
  }

  String _formatBitRate(int bitRate) {
    if (bitRate < 1024) {
      return '${bitRate}bps';
    } else if (bitRate < 1024 * 1024) {
      return '${(bitRate / 1024).round()}kbps';
    } else {
      return '${(bitRate / 1024 / 1024).round()}mbps';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours > 0 ? '${duration.inHours}:' : '';
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours$minutes:$seconds';
  }
}
