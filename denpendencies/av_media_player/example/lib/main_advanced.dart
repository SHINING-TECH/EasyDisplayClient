import 'dart:core';
import 'package:flutter/material.dart';
import 'track_selector_view.dart';
import 'video_list_view.dart';
import 'video_player_view.dart';

void main() => runApp(const AppView());

enum AppRoute {
  videoPlayer,
  videoList,
  trackSelector,
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  var _appRoute = AppRoute.values.first;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('AvMediaPlayer advanced example'),
          ),
          body: _buildBody(),
          bottomNavigationBar: BottomNavigationBar(
            items: AppRoute.values.map(_buildBottomNavigationBarItem).toList(),
            currentIndex: _appRoute.index,
            onTap: (index) =>
                setState(() => _appRoute = AppRoute.values[index]),
          ),
        ),
      );

  Widget _buildBody() {
    switch (_appRoute) {
      case AppRoute.trackSelector:
        return const TrackSelectorView();
      case AppRoute.videoPlayer:
        return const VideoPlayerView();
      case AppRoute.videoList:
        return const VideoListView();
    }
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(AppRoute route) {
    switch (route) {
      case AppRoute.trackSelector:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: 'Track Selector',
        );
      case AppRoute.videoPlayer:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.smart_display),
          label: 'Video Player',
        );
      case AppRoute.videoList:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.view_stream),
          label: 'Video List',
        );
    }
  }
}
