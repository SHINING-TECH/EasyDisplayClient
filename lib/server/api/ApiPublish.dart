import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:shelf/shelf.dart';
import 'package:snap_vison_client/config/app_config.dart';
import '../../database/database.dart';
import '../../database/database_manager.dart'; // 引入数据库管理器
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';
import '../../database/database.dart';
import '../../database/database_manager.dart';
import '../../event/event_bus.dart';
import '../../event/program_event.dart';
import '../../l10n/localization.dart';
import '../../pages/test_page.dart'; // 引入数据库管理器

class ApiPublish {
  final DatabaseManager _dbManager = DatabaseManager();

  /**
   * web端新建节目发布
   */
  Future<Response> createPublish(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final String? userName = data['userName'];
      final String? programName = data['programName'];
      final String? date = data['date'];
      final String? disStrategy = data['disStrategy'];
      final String? disType = data['disType'];
      final String? invalidTime = data['invalidTime'];
      final String? makeTime = data['makeTime'];
      final String? playMode = data['playMode'];
      final String? proId = data['proId'];
      final int? proType = data['proType'];
      final String? publisher = data['publisher'];
      final String? terminalId = data['terminalId'];
      final String? time = data['time'];
      final String? type = data['type'];

      if(userName!=null){
        //插入操作记录
        _dbManager.insertRecord(userName,"${L10n.getStringWithoutContext('log_publish')} ${L10n.getStringWithoutContext('log_terminal_id')}:${terminalId},${L10n.getStringWithoutContext('log_program_name')}:${programName}");
      }
      final int publishId = await _dbManager.createServerPublish(
          programName,
          date,
          disStrategy,
          disType,
          invalidTime,
          makeTime,
          playMode,
          proId,
          proType,
          publisher,
          terminalId,
          time,
          type);

      //绘制并播放节目
      //Step 根据proID(节目ID)查询节目数据
      eventBus.fire(ProgramIdEvent(AppConfig.publishProgram,publishId));

      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': '创建成功',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } catch (e, stackTrace) {
      // 打印堆栈跟踪信息
      print('Error creating publish: $e');
      print('Stack trace: $stackTrace');

      return Response.internalServerError(body: 'Error creating publish: $e');
    }
  }

  /**
   * 获取所有节目发布数据，支持分页
   */
  Future<Response> getAllPublishes(Request request) async {
    // 从查询参数中获取 page
    final queryParams = request.url.queryParameters;
    final int page = int.tryParse(queryParams['page'] ?? '1') ?? 1; // 默认页码为 1

    // 从数据库获取所有节目发布数据
    List<ServerPublishData> publishes = await _dbManager.getAllServerPublishes();

    // 分页处理
    final int pageSize = 10; // 每页显示的节目发布数据数量
    final int startIndex = (page - 1) * pageSize;
    final List<ServerPublishData> paginatedPublishes =
    publishes.skip(startIndex).take(pageSize).toList();

    // 将节目发布数据转换为 JSON 格式
    final List<Map<String, dynamic>> publishList = paginatedPublishes.map((publish) {
      return {
        'publishId': publish.id,
        'programName': publish.programName,
        'date': publish.createdAt.toIso8601String().substring(0, 19).replaceAll('T', ' '),
        'disStrategy': publish.disStrategy,
        'disType': publish.disType,
        'invalidTime': publish.invalidTime,
        'makeTime': publish.makeTime,
        'playMode': publish.playMode,
        'proId': publish.proId,
        'proType': publish.proType,
        'publisher': publish.publisher,
        'terminalId': publish.terminalId,
        'time': publish.time,
        'type': publish.type,
      };
    }).toList();

    // 构建响应数据结构
    final responseData = {
      'publish': publishList,
      'pages': {
        'count': (publishes.length / pageSize).ceil(), // 总页数
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


  Future<Response> deleteServerPublishById(Request request) async {
    final queryParams = request.url.queryParameters;
    final String? userName = queryParams['userName'];
    final String? deleteId = queryParams['ids'];

    // 检查 deleteId 是否为 null 或空字符串
    if (deleteId == null || deleteId.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '-1',
          'message': '缺少发布 ID',
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

    for (String proId in idList) {
      final int? idInt = int.tryParse(proId);
      // 检查 idInt 是否为 null
      if (idInt == null) {
        print("无效的发布 ID: $proId");
        continue; // 跳过无效的 ID
      }
      if(userName!=null){
        //插入操作记录
        _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_delete_publish')} :${L10n.getStringWithoutContext('log_terminal_id')}:${idList}");
      }
      final result = await _dbManager.deleteServerPublishById(idInt);
      print("删除发布id: $idInt result:${result}");
      // 发送事件通知删除节目
      eventBus.fire(ProgramIdEvent(AppConfig.deleteProgram,idInt));

    }

    // 返回删除结果
    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '删除发布计划成功',
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
