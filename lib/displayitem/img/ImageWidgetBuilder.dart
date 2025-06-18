import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../database/database.dart';
import '../../database/database_manager.dart';
import '../BaseDisplayWidget.dart';
import 'ImageItemData.dart';

class ImageWidgetBuilder extends BaseDisplayWidget {
  @override
  Future<Widget> buildWidget(int programId, Map<String, dynamic> item) async {
    String itemID = item['id'];
    print("构建图片区域显示组件 模板区域id: ${itemID}");

    ProgramItem? programItemData = await queryProgramItem(programId, itemID);
    if (programItemData == null) {
      return handleEmptyProgramItem('Abnormal image area');
    }

    print("查询到的节目中这个模板图片区域的配置:${programItemData.toJson()}");

    List<ImageItemData> imageList = parseJsonData(
      programItemData.url ?? "[]",
          (json) => ImageItemData.fromJson(json),
    );

    if (imageList.isEmpty) {
      return handleEmptyItemList('No image found');
    }

    if (imageList.length == 1) {
      return await _buildSingleImage(imageList.first);
    } else {
      return await _buildImageCarousel(imageList);
    }
  }

  Future<Widget> _buildSingleImage(ImageItemData imageItem) async {
    String localPath = await _resolveImagePath(imageItem);
    if (localPath.isNotEmpty) {
      print("加载本地图片: $localPath");
      return Image.file(File(localPath), fit: BoxFit.fill);
    } else {
      print("加载网络图片: ${imageItem.url}");
      return Image.network(imageItem.url, fit: BoxFit.fill);
    }
  }

  Future<String> _resolveImagePath(ImageItemData imageItem) async {
    String resourceIdStr = imageItem.resourceId;
    if (resourceIdStr.isNotEmpty) {
      try {
        int resourceId = int.parse(resourceIdStr);
        DatabaseManager _dbManager = DatabaseManager();
        ResourceData? resource = await _dbManager.getResourceById(resourceId);
        if (resource != null && resource.localFilePath.isNotEmpty) {
          return resource.localFilePath;
        }
      } catch (e) {
        print("解析 resourceId 失败: $e");
      }
    }
    return '';
  }

  Future<Widget> _buildImageCarousel(List<ImageItemData> imageList) async {
    final List<Widget> items = [];

    for (var item in imageList) {
      String localPath = await _resolveImagePath(item);
      Widget imageWidget = localPath.isNotEmpty
          ? Image.file(File(localPath), fit: BoxFit.fill,width: double.infinity,height: double.infinity)
          : Image.network(item.url, fit: BoxFit.fill,width: double.infinity,height: double.infinity);
      items.add(imageWidget);
    }
    //imageList.first.translateTime ?? 5
    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: imageList.first.translateTime ?? 5),//切换时间
        autoPlayAnimationDuration: const Duration(milliseconds: 800),//切换动画时间 - 设置为10，看起来就是立刻切换
        autoPlayCurve: Curves.ease,
        enlargeCenterPage: false,
        scrollPhysics: const ClampingScrollPhysics(),
      ),
    );
  }

  @override
  void dispose() {
    // 不需要释放资源
  }
}
