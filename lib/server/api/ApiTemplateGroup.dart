import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart';

/**
 * 获取模板组 API
 */
class ApiTemplateGroup {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<Response> getAllTemplateGroups(Request request) async {
    // 获取所有父模板组（fatherId 为空）
    final parentGroups = await _dbManager.getAllParentTemplateGroups();


    // 将模板组转换为 JSON 格式，同时获取每个父组下的子组
    final List<Map<String, dynamic>> templateGroupTree = await Future.wait(parentGroups.map((parent) async {
      final childGroups = await _dbManager.getTemplateGroupsByFatherId(parent.id);
      final childGroupList = childGroups.map((child) {
        return {
          'id': child.id,
          'label': child.label,
          // 这里可以添加更多子组的字段
        };
      }).toList();

      return {
        'id': parent.id,
        'label': parent.label,
        'groups': childGroupList,
      };
    }).toList());

    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '获取成功',
        'data': templateGroupTree,
      }),
      headers: {
        'Content-Type': 'application/json',
        ..._getCorsHeaders(),
      },
    );
  }

  /**
   * 创建模板组API
   */
  Future<Response> createTemplateGroup(Request request) async {
    final payload = await request.readAsString();
    print('Received createTemplateGroup: $payload');

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
    final label = data['label'];
    final fatherId = data['fatherId']; // 假设模板组有父ID字段

    if (label == null) {
      return Response.badRequest(
        body: 'Missing required field: label',
        headers: _getCorsHeaders(),
      );
    }

    try {
      _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_create_template_group')}:${label}");
      int groupId = await _dbManager.addChildTemplateGroup(label, fatherId);
      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': 'Template group created successfully',
          'data': {
            'groupId': groupId,
            'label': label,
            'fatherId': fatherId
          }
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: 'Failed to create template group: $e',
        headers: _getCorsHeaders(),
      );
    }
  }


  /**
   * 删除模板组API
   */
  Future<Response> deleteTemplateGroup(Request request) async {
    final payload = await request.readAsString();
    print('Received deleteTemplateGroup: $payload');

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
    final groupIdValue = data['groupId'];
    int? groupId;
    if (groupIdValue is int) {
      groupId = groupIdValue;
    } else if (groupIdValue is String) {
      groupId = int.tryParse(groupIdValue);
    }

    if (groupId == null) {
      return Response.badRequest(
        body: 'Missing required field: groupId',
        headers: _getCorsHeaders(),
      );
    }

    try {
      //根据groupIdValue查询模板组名称
      final groupData = await _dbManager.getTemplateGroupById(groupId);
      if (groupData != null) {
        await _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_delete_template_group')}:${groupData.label}");
      }
      await _dbManager.deleteTemplatesByGroupId(groupId);
      //删除模板组
      await _dbManager.deleteTemplateGroup(groupId);
      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': 'Template group deleted successfully',
          'data': {
            'groupId': groupId
          }
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: 'Failed to delete template group: $e',
        headers: _getCorsHeaders(),
      );
    }
  }

  // 提取CORS headers为一个方法，避免重复代码
  Map<String, String> _getCorsHeaders() => {
    'Access-Control-Allow-Origin': 'http://localhost:8666',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };
}