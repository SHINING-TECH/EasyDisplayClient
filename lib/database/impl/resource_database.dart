import 'dart:io';

import 'package:drift/drift.dart';
import '../../manager/file_path_manager.dart';
import '../database.dart'; // 引入主数据库类
import 'package:path/path.dart' as p; // 导入 path 包

part 'resource_database.g.dart';


@DriftAccessor(tables: [Resource])
class ResourceDatabase extends DatabaseAccessor<AppDatabase> with _$ResourceDatabaseMixin {
  ResourceDatabase(AppDatabase db) : super(db);

  // 初始化默认模资源
  Future<void> initDefaultResource() async {
    final existingTemplates = await getAllResources();
    if (existingTemplates.isEmpty) {
      await addResource('image',1,'bg1.jpg',"image/bg1.jpg","image/bg1_tn.jpg","image/bg1.jpg",0,"unKnow");
      await addResource('image',1,'bg2.jpg',"image/bg2.jpg","image/bg2_tn.jpg","image/bg2.jpg",0,"unKnow");
      await addResource('video',2,'v1.mp4',"video/v1.mp4","video/v1_tn.mp4","video/v1.mp4",0,"unKnow");
      await addResource('video',2,'v2.mp4',"video/v2.mp4","video/v2_tn.mp4","video/v2.mp4",0,"unKnow");
      await addResource('audio',3,'m1.mp3',"audio/m1.mp4","audio/m1_tn.mp4","audio/m1.mp4",0,"unKnow");
    }
  }

  // 添加资源
  Future<int> addResource(String type,int groupId,String name,String url,String thumbnail,String localFilePath,int size,String showFileSize) async {
    return await into(resource).insert(
      ResourceCompanion.insert(
        type:type,
        groupId: Value(groupId),
        name: name,
        url: url,
        thumbnail: thumbnail,
        localFilePath: localFilePath,
        fileSize: Value(size),
        showFileSize: showFileSize
      ),
    );
  }

   /**
   * 删除资源
   * 返回 localFilePath 如果删除成功，否则返回空串
   */
  Future<ResourceData?> deleteResourceById(int id) async {
    String videoThumbnailDir = "";
    // 获取要删除的资源
    final resourceToDelete = await (select(resource)..where((tbl) => tbl.id.equals(id))).get();

    if (resourceToDelete.isNotEmpty) {
      // 获取 localFilePath
      final localFilePath = resourceToDelete.first.localFilePath;
      //删除Video文件本地缩略图
      if(resourceToDelete.first.type == "video"){
        if (resourceToDelete.first.thumbnail.isNotEmpty) {
          if(videoThumbnailDir.isEmpty){
            videoThumbnailDir = await FilePathManager.getUploadResourceDirectory("video");
          }
          String videothumbilePath = p.join(videoThumbnailDir, resourceToDelete.first.thumbnail);
          final file = File(videothumbilePath);
          if (await file.exists()) {
            print("删除视频缩略图: $videothumbilePath");
            await file.delete();
          }
        }
      }

      // 执行删除操作
      await (delete(resource)..where((tbl) => tbl.id.equals(id))).go();
      // 返回 localFilePath
      return resourceToDelete.first;
    }
    // 如果没有找到资源，返回空串
    return null;
  }

  // 获取所有资源
  Future<List<ResourceData>> getAllResources() async {
    return await select(resource).get();
  }

  // 根据 groupId 查询资源
  Future<List<ResourceData>> getResourcesByGroupId(int groupId) async {
    return await (select(resource)..where((tbl) => tbl.groupId.equals(groupId))).get();
  }

  // 根据 groupId 查询资源，返回资源的 id 集合
  Future<List<int>> getResourceIdsByGroupId(int groupId) async {
    final result = await (select(resource)..where((tbl) => tbl.groupId.equals(groupId))).get();
    return result.map((resource) => resource.id).toList();
  }

  //根据资源id查询资源实体类
  Future<ResourceData?> getResourceById(int id) async {
    return await (select(resource)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}