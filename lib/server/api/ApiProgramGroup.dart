import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart';

/**
 * 节目组 API
 */
class ApiProgramGroup {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<Response> getAllProgramGroups(Request request) async {
    // 调用数据库方法获取树结构数据
    final programGroupTree = await getAllParentProgramGroupsAsTree();

    return Response.ok(
      jsonEncode(programGroupTree),
      headers: {
        'Content-Type': 'application/json',
        ..._getCorsHeaders(),
      },
    );
  }

  Future<Map<String, dynamic>> getAllParentProgramGroupsAsTree() async {
    final parentGroups = await _dbManager.getAllParentProgramGroups();
    final List<Map<String, dynamic>> groupTree = [];

    for (final group in parentGroups) {
      final groupNode = {
        "id": group.id,
        "label": group.label,
        "groups": await buildGroupTree(group.id)
      };
      groupTree.add(groupNode);
    }

    return {
      "code": "0",
      "message": "获取成功",
      "data": groupTree
    };
  }

  Future<List<Map<String, dynamic>>> buildGroupTree(int? fatherId) async {
    final childGroups = await _dbManager.getProgramGroupsByFatherId(fatherId!);
    final List<Map<String, dynamic>> childTree = [];

    for (final childGroup in childGroups) {
      final childNode = {
        "id": childGroup.id,
        "label": childGroup.label,
        "groups": await buildGroupTree(childGroup.id)
      };
      childTree.add(childNode);
    }

    return childTree;
  }

  // 添加新的方法来插入带有 fatherId 的节目组数据
  Future<Response> addProgramGroup(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final userName = data['userName'];
    final label = data['label'] as String;
    final fatherId = data['fatherId'] as int?;
    print("创建节目组 userName:$userName label:$label,父id:$fatherId");
    //插入操作记录
    _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_create_program_group')}:${label}");
    // 调用 DatabaseManager 中的新方法
    final newGroup = await _dbManager.addProgramGroupWithFatherId(label, fatherId);

    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '添加成功',
      }),
      headers: {
        'Content-Type': 'application/json',
        ..._getCorsHeaders(),
      },
    );
  }

  // 删除组及其所有子组的 API 接口
  Future<Response> deleteProgramGroup(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    // 使用 int.tryParse 进行容错处理
    final userName = data['userName'];
    final groupIdStr = data['groupId'] as String?;
    final groupId = int.tryParse(groupIdStr ?? '');

    if (groupId == null) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '1',
          'message': '无效的组 ID，必须是有效的整数',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }
    print("删除节目组: $groupId");
    try {
      //插入操作记录
      //根据ID查询出组的名称
      final group = await _dbManager.getProgramGroupById(groupId);
      if (group != null) {
        await _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_delete_program_group')} :${group.label}");
      }
      await _dbManager.deleteProgramGroupAndChildren(groupId);
      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': '删除成功',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } catch (e) {
      print('删除节目组时出错: $e');
      return Response.internalServerError(
        body: jsonEncode({
          'code': '1',
          'message': '删除失败: $e',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
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