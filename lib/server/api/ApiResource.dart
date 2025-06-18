import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/shelf_multipart.dart';
import 'package:snap_vison_client/manager/file_path_manager.dart';
import '../../database/database.dart';
import '../../database/database_manager.dart';
import 'package:path/path.dart' as p;

import '../../l10n/localization.dart'; // 导入 path 包

/**
 * 资源 API
 */
class ApiResource {
  final DatabaseManager _dbManager = DatabaseManager();

  /**
   * 查询资源
   */
  Future<Response> getResource(Request request) async {
    // 从查询参数中获取 type、page 和 groupId
    final queryParams = request.url.queryParameters;
    final String? type = queryParams['type'];
    final int page = int.tryParse(queryParams['pageNo'] ?? '1') ?? 1; // 默认页码为 1
    // 从查询参数中获取每页数据量，默认 10，范围在 1 到 100 之间
    final int pageCount =
        (int.tryParse(queryParams['pageCount'] ?? '10') ?? 10).clamp(1, 100);

    final String? groupIdStr = queryParams['groupId'];
    int? groupIdInt;

    if (groupIdStr != null && groupIdStr.isNotEmpty) {
      groupIdInt = int.tryParse(groupIdStr);
      if (groupIdInt == null) {
        return Response.badRequest(
          body: jsonEncode({
            'code': '-1',
            'message': '无效的 groupId，必须为整数',
          }),
          headers: {
            'Content-Type': 'application/json',
            ..._getCorsHeaders(),
          },
        );
      }
    }

    List<ResourceData> resources;
    if (groupIdInt != null) {
      // 如果传入了有效的 groupId，查询这个资源组下的数据
      resources = await _dbManager.getResourcesByGroupId(groupIdInt);
    } else {
      // 从数据库获取所有资源
      resources = await _dbManager.getAllResources();
    }

    // 根据 type 过滤资源
    if (type != null && type.isNotEmpty) {
      resources = resources.where((resource) => resource.type == type).toList();
    }

    // 分页处理
    final int startIndex = (page - 1) * pageCount;
    final List<ResourceData> paginatedResources =
        resources.skip(startIndex).take(pageCount).toList();

    // 计算总页数
    final int totalCount = resources.length;
    final int totalPages = (totalCount / pageCount).ceil();

    // 将资源转换为 JSON 格式
    final List<Map<String, dynamic>> resourceList =
        paginatedResources.map((template) {
      return {
        'id': template.id,
        'url': template.url,
        'thumbnail': template.thumbnail,
        'name': template.name,
        'type': template.type,
        'size': template.showFileSize,
        // 如果有时间字段，确保将 DateTime 转换为字符串
        'createTime': template.createdAt
            .toIso8601String()
            .substring(0, 19)
            .replaceAll('T', ' '), // 转换为字符串
        'upDateTime': template.updatedAt
            .toIso8601String()
            .substring(0, 19)
            .replaceAll('T', ' '), // 转换为字符串
      };
    }).toList();

    // 构建响应数据结构
    final responseData = {
      'resources': resourceList,
      'pages': {
        'totalCount': totalCount, // 总记录数
        'totalPages': totalPages, // 总页数
        'pageSize': pageCount, // 每页显示数量
        'currentPage': page, // 当前页码
      },
    };

    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '获取成功',
        'data': responseData,
      }),
      headers: {
        'Content-Type': 'application/json',
        ..._getCorsHeaders(),
      },
    );
  }

  /**
   * 上传资源
   */
  Future<Response> upLoadResourceFile(Request request) async {
    print("startUpload");
    if (request.formData() case var form?) {
      //第一次遍历获取参数信息
      String userName = "";
      int? groupId = 0;
      String fileType = "";
      String? filename = "";
      String path = "";
      int fileSizeKB = 0; // 新增变量用于存储文件大小
      String showFileSize = "unKnow";
      await for (final formData in form.formData) {
        if (formData.name == "type") {
          // 获取 type 对应的值
          fileType = await formData.part.readString(); // 读取字符串内容
          print("File type: $fileType");
        } else if (formData.name == "groupId") {
          String groupIdStr = await formData.part.readString();
          groupId = int.tryParse(groupIdStr);
          if (groupId == null) {
            // 处理转换失败的情况，例如返回错误响应
            return Response.badRequest(
              body: jsonEncode({
                'code': '-1',
                'message': '无效的 groupId，必须为整数',
              }),
              headers: {
                'Content-Type': 'application/json',
                ..._getCorsHeaders(),
              },
            );
          }
          print("File groupID: $groupId");
        } else if (formData.name == "username") {
          userName = await formData.part.readString();
          print("Upload By userName: $userName");
        } else if (formData.name == "file") {
          print('${formData.name} ${formData.filename}');
          final uploadDir = await FilePathManager.getUploadResourceDirectory(
              fileType); // 指定上传目录
          filename = formData.filename;
          print("filename: ${filename}");
          path = p.join(uploadDir, filename!);
          print("server save path: $path");
          File file = File(path);
          IOSink sink = file.openWrite();
          await formData.part.pipe(sink);
          await sink.close(); // 关闭 sink

          // 文件存储到本地后获取文件大小
          int fileSizeBytes = await file.length();
          if (fileSizeBytes >= 1024 * 1024) {
            double fileSizeMB = fileSizeBytes / (1024 * 1024);
            showFileSize = '${fileSizeMB.toStringAsFixed(2)} MB'; // 保留两位小数
          } else {
            double fileSizeKB = fileSizeBytes / 1024;
            showFileSize = '${fileSizeKB.toStringAsFixed(2)} KB'; // 保留两位小数
          }
          print("File size: $showFileSize");
        }
      }
      String videothumbileFileName = filename!!;
      //插入本地数据库
      print(
          "插入资源数据库\nfileType:${fileType}\nfilename:${filename}\npath:${path}");
      if (fileType == "video") {
        print("视频文件,获取第一帧");
        final videoThumbnailDir =
            await FilePathManager.getUploadResourceDirectory("video"); // 指定上传目录
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        videothumbileFileName = "${timestamp}_tn.jpg";
        String videothumbilePath =
            p.join(videoThumbnailDir, videothumbileFileName);
        final plugin = FcNativeVideoThumbnail();
        try {
          final thumbnailGenerated = await plugin.getVideoThumbnail(
              srcFile: path,
              destFile: videothumbilePath,
              width: 800,
              height: 600,
              format: 'jpeg',
              quality: 90);
          if (thumbnailGenerated) {
            print("缩略图生成成功: $videothumbilePath");
          } else {
            print("缩略图生成失败");
          }
        } catch (err) {
          print("获取视频缩略图失败:$err");
        }
      }
      //写操作日志
      _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_upload_resource')} : :${filename}");
      await _dbManager.addResources(fileType, groupId as int, filename!!,
          filename, videothumbileFileName, path, fileSizeKB, showFileSize);
      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': '上传成功',
          'data': "",
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } else {
      return Response.ok(
        jsonEncode({
          'code': '-1',
          'message': '上传失败',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }
  }

  Future<Response> deleteResource(Request request) async {
    final queryParams = request.url.queryParameters;
    final String userName = queryParams['userName'] ?? '';
    final String? deleteId = queryParams['ids'];

    // 检查 deleteId 是否为 null 或空字符串
    if (deleteId == null || deleteId.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '-1',
          'message': '缺少资源 ID',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }

    // 将 deleteId 分割为 ID 列表
    final List<String> idList = deleteId.split(" ");
    List<String> deletedFilePaths = []; // 存储已删除文件路径

    for (String resourceId in idList) {
      final int? idInt = int.tryParse(resourceId);

      // 检查 idInt 是否为 null
      if (idInt == null) {
        print("无效的资源 ID: $resourceId");
        continue; // 跳过无效的 ID
      }
      print("删除资源id: $idInt");
      final deleteResource = await _dbManager.deleteResource(idInt);
      if (deleteResource != null) {
        final localFilePath = deleteResource.localFilePath;
        print("删除本地文件: $localFilePath");
        //写入操作日志
        _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_delete_resource')}:${deleteResource.name}");
        final file = File(localFilePath);
        if (await file.exists()) {
          await file.delete();
          print("File $localFilePath deleted successfully.");
          deletedFilePaths.add(localFilePath); // 添加到已删除文件路径列表
        } else {
          print("File $localFilePath does not exist.");
        }
      }
    }

    // 返回删除结果
    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '资源删除成功',
        'deletedFilePaths': deletedFilePaths, // 返回已删除的文件路径
      }),
      headers: {
        'Content-Type': 'application/json',
        ..._getCorsHeaders(),
      },
    );
  }

  // 提取CORS headers为一个方法，避免重复代码
  Map<String, String> _getCorsHeaders() => {
        'Access-Control-Allow-Origin': 'http://localhost:8666',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      };
}
