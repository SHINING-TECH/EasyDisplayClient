import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:snap_vison_client/database/database_manager.dart';

import '../../database/database.dart';
import '../BaseDisplayWidget.dart';
import 'VideoItemData.dart';

/**
 *  视频区域显示组件
 */
class VideoWidgetBuilder extends BaseDisplayWidget {
  Player? _player;
  VideoController? _controller;

  @override
  Future<Widget> buildWidget(int programId, Map<String, dynamic> item) async {
    String itemID = item['id'];
    print("构建视频区域显示组件 模板区域id: ${itemID}");
    ProgramItem? programItemData = await queryProgramItem(programId, itemID);
    if (programItemData == null) {
      return handleEmptyProgramItem('Abnormal Video area');
    }

    print("查询到的节目中这个模板视频区域的配置:${programItemData.toJson()}");

    List<VideoItemData> videoList = parseJsonData(
      programItemData.url ?? "[]",
          (json) => VideoItemData.fromJson(json),
    );

    if (videoList.isEmpty) {
      return handleEmptyItemList('No Video found');
    }

    return buildVideoPlayer(videoList);
  }

  Future<Widget> buildVideoPlayer(List<dynamic> videoList) async {
    _player = Player();
    _controller = VideoController(_player!);

    final List<Media> mediaList = await Future.wait(videoList.map<Future<Media>>(
          (item) async {
        String videoUrl = item.url;
        String resourceIdStr = item.resourceId;
        String localPath = '';

        if (resourceIdStr.isNotEmpty) {
          try {
            int resourceId = int.parse(resourceIdStr);
            print("视频资源Id: $resourceId");
            DatabaseManager _dbManager = DatabaseManager();
            // 根据资源ID查询资源实体类
            ResourceData? resource = await _dbManager.getResourceById(resourceId);
            print("获取视频资源数据: $resource");
            if (resource != null && resource.localFilePath.isNotEmpty) {
              localPath = resource.localFilePath;
            }
          } catch (e) {
            print("解析 resourceId 失败: $e");
          }
        }

        if (localPath.isNotEmpty) {
          print("加载本地视频: $localPath");
          return Media(File(localPath).uri.toString());
        } else {
          print("加载网络视频: $videoUrl");
          return Media(videoUrl);
        }
      },
    ));

    final playable = Playlist(mediaList);
    await _player!.open(playable);
    await _player!.setPlaylistMode(PlaylistMode.loop);
    return Video(
      fit: BoxFit.fill,
      controller: _controller!,
      controls: null,
    );
  }

  @override
  void dispose() {
    print("视频区域销毁!");
    _player?.dispose();
    _player = null;
    _controller = null;
  }
}
