import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart';

/**
 * 资源类型，资源组操作
 */
class ApiResourceType {
  final DatabaseManager _dbManager = DatabaseManager();

  /**
   * 获取所有资源类型API
   */
  Future<Response> getAllResourceTypes(Request request) async {
    // 从数据库获取所有资源类型
    final resourceType = await _dbManager.getAllResourceType();

    // 将模板转换为 JSON 格式，同时获取每个类型下的分组
    final List<Map<String, dynamic>> resourceTypeList = await Future.wait(resourceType.map((template) async {
      final groups = await _dbManager.getResourceGroupsByType(template.type);
      final groupList = groups.map((group) {
        return {
          'id': group.id,
          'groupName': group.groupName,
          'type':group.type
          // 这里可以添加更多分组的字段
        };
      }).toList();

      return {
        'id': template.id,
        'label': template.label,
        'type': template.type,
        'groups': groupList,
      };
    }).toList());

    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '获取成功',
        'data': resourceTypeList,
      }),
      headers: {
        'Content-Type': 'application/json',
        ..._getCorsHeaders(),
      },
    );
  }

  /**
   * 创建资源组API
   */
  Future<Response> createResourceGroup(Request request) async {
    final payload = await request.readAsString();
    print('Received createResourceGroup: $payload');

    Map<String, dynamic> data;
    try {
      data = jsonDecode(payload);
    } catch (e) {
      return Response.badRequest(
        body: 'Invalid JSON format',
        headers: _getCorsHeaders(),
      );
    }

    final userName = data['userName'];
    final type = data['type'];
    final groupName = data['groupName'];

    if (type == null || groupName == null) {
      return Response.badRequest(
        body: 'Missing required fields: type or groupName',
        headers: _getCorsHeaders(),
      );
    }

    try {
      //写入操作日志
      _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_create_resource_group')} :${groupName}");
      int groupId = await _dbManager.addResourceGroup(type, groupName);
      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': 'Resource group created successfully',
          'data': {
            'groupId': groupId,
            'type': type,
            'groupName': groupName
          }
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: 'Failed to create resource group: $e',
        headers: _getCorsHeaders(),
      );
    }
  }


  /**
   * 删除资源组API
   */
  Future<Response> deleteResourceGroup(Request request) async {
    final payload = await request.readAsString();
    print('Received deleteResourceGroup: $payload');

    Map<String, dynamic> data;
    try {
      data = jsonDecode(payload);
    } catch (e) {
      return Response.badRequest(
        body: 'Invalid JSON format',
        headers: _getCorsHeaders(),
      );
    }

    final userName = data['userName'];
    final groupIdStr = data['groupId'];
    final int? groupId = int.tryParse(groupIdStr);

    // 检查 groupId 是否为有效的整数
    if (groupId == null) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '-1',
          'message': '无效的资源组 ID，必须为整数',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }
    //插入操作日志
    String groupName = await _dbManager.getResourceGroupNameById(groupId);
    _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_delete_resource_group')} :${groupName}");
    // 获取该资源组内的所有资源 ID
    final List<int> resourceIds = await _dbManager.getResourceIdsByGroupId(groupId);

    List<String> deletedFilePaths = []; // 存储已删除文件路径

    for (int resourceId in resourceIds) {
      print("删除资源组内资源 id: $resourceId");
      final deleteResource = await _dbManager.deleteResource(resourceId);
      if (deleteResource != null) {
        final localFilePath = deleteResource.localFilePath;
        print("删除本地文件: $localFilePath");
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
    // 删除资源组
    await _dbManager.deleteResourceGroup(groupId);
    // 返回删除结果
    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '资源组及组内资源删除成功',
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