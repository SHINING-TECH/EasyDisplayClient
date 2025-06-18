import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart';

/**
 * 终端组 API
 */
class ApiTerminalGroup {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<Response> getAllTerminalGroups(Request request) async {
    // 从数据库获取所有终端组
    final templates = await _dbManager.getAllTerminalGroups();

    // 将模板转换为 JSON 格式
    final List<Map<String, dynamic>> templateList = templates.map((template) {
      return {
        'id': template.id,
        'label': template.label,
      };
    }).toList();

    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '获取成功',
        'data': templateList,
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