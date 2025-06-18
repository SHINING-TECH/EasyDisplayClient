import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart';
import '../../database/database.dart';

class ApiOperationRecord {
  final DatabaseManager _dbManager = DatabaseManager();

  /**
   * 查询操作记录
   */
  Future<Response> getOperationRecord(Request request) async {
    try {
      // 从查询参数中获取 userId、page 和 pageSize
      final queryParams = request.url.queryParameters;
      final int userId = int.tryParse(queryParams['userId'] ?? '-1') ?? -1;
      final int page = int.tryParse(queryParams['pageNo'] ?? '1') ?? 1; // 默认页码为 1
      final int pageSize = int.tryParse(queryParams['pageCount'] ?? '10') ?? 10; // 默认每页数量为 10


      // 从数据库获取操作记录
      final records = await _dbManager.getRecordsByUserId(userId);

      // 分页处理
      final int startIndex = (page - 1) * pageSize;
      final List<OperationRecord> paginatedRecords = records.skip(startIndex).take(pageSize).toList();

      // 将操作记录转换为 JSON 格式
      final List<Map<String, dynamic>> recordList = paginatedRecords.map((record) {
        return {
          'id': record.id,
          'userName': record.userName,
          'userId': record.userId,
          'operationDetail': record.operationDetail,
          'operationTime': record.operationTime.toIso8601String().substring(0, 19).replaceAll('T', ' '),
        };
      }).toList();

      // 构建响应数据结构
      final responseData = {
        'records': recordList,
        'pages': {
          'totalCount': records.length, // 总记录数
          'totalPages': (records.length / pageSize).ceil(), // 总页数
          'pageSize': pageSize, // 每页显示数量
          'currentPage': page, // 当前页码
        },
      };

      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': '获取操作记录成功',
          'data': responseData,
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } catch (e) {
      return Response(500,
        body: jsonEncode({
          'code': '2',
          'message': '获取操作记录时出错: ${e.toString()}',
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