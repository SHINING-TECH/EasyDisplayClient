// This example shows how to use a Texture widget to display video.
// Please note that the SetStateAsync mixin is necessary cause setState() may be called during build process.

import 'package:flutter/material.dart';
import 'package:av_media_player/player.dart';
import 'package:av_media_player/utils.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'sources.dart';

class VideoListView extends StatefulWidget {
  const VideoListView({super.key});

  @override
  State<VideoListView> createState() => _VideoListView();
}

class _VideoListView extends State<VideoListView> with SetStateAsync {
  final _players = <AvMediaPlayer>[];

  void _update() => setState(() {});

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < videoSources.length; i++) {
      final player = AvMediaPlayer(initLooping: true);
      // Listening to mediaInfo is optional in this case.
      // As loading always becomes false when mediaInfo is perpared.
      // player.mediaInfo.addListener(() => setState(() {}));
      player.loading.addListener(_update);
      player.videoSize.addListener(_update);
      _players.add(player);
    }
  }

  @override
  void dispose() {
    // We should dispose all the players. cause they are managed by the user.
    for (final player in _players) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InViewNotifierList(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 200),
        isInViewPortCondition:
            (double deltaTop, double deltaBottom, double viewPortDimension) =>
                deltaTop < (0.5 * viewPortDimension) &&
                deltaBottom > (0.5 * viewPortDimension),
        builder: (context, index) => InViewNotifierWidget(
          id: '$index',
          child: Container(
            margin: index == _players.length - 1
                ? null
                : const EdgeInsets.only(bottom: 16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // We can use Texture widget instead of AvMediaView to display video.
                  // But we have to make sure the player is initialized first. (_players[index].id.value != null)
                  // In this case we check _players[index].videoSize.value != Size.zero which also guarantees the player is initialized.
                  _players[index].videoSize.value != Size.zero
                      ? Texture(textureId: _players[index].id.value!)
                      : Container(color: Colors.black),
                  if (_players[index].mediaInfo.value != null &&
                      _players[index].videoSize.value == Size.zero)
                    const Text(
                      'Audio only',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  if (_players[index].loading.value)
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          builder: (context, isInView, child) {
            if (isInView) {
              // We should open the video only if it's not already opened and not loading.
              if (_players[index].mediaInfo.value == null &&
                  !_players[index].loading.value) {
                _players[index].open(videoSources[index]);
              }
              _players[index].play();
            } else {
              _players[index].pause();
            }
            return child!;
          },
        ),
        itemCount: _players.length,
      );
}
