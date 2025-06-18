// This example shows how to use the AvMediaView widget to play a video from a URL.
// Which is a very basic way to use av_media_player package.
// For more advanced usage, see main_advanced.dart.

import 'package:flutter/material.dart';
import 'package:av_media_player/widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _loading = true;
  @override
  Widget build(BuildContext context) => Stack(
        textDirection: TextDirection.ltr,
        alignment: Alignment.center,
        children: [
          AvMediaView(
            initSource:
                'https://test-streams.mux.dev/x36xhzz/url_6/193039199_mp4_h264_aac_hq_7.m3u8',
            initLooping: true,
            initAutoPlay: true,
            onCreated: (player) => player.loading.addListener(
                () => setState(() => _loading = player.loading.value)),
          ),
          if (_loading) const CircularProgressIndicator(),
        ],
      );
}
