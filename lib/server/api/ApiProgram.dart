import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';
import '../../database/database.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart'; // 引入数据库管理器

class ApiProgram {
  final DatabaseManager _dbManager = DatabaseManager();

  /**
   * 新建节目
   */
  Future<Response> newProgram(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final List<ProgramItemsCompanion> temItems = (data['proItems'] as List)
          .map((item) => ProgramItemsCompanion.insert(
                itemsId: item['itemsId'],
                url: item['url'],
              ))
          .toList();

      final String userName = data['userName'];
      final int groupId = data['groupId'];
      final int modelId = data['modelId'];
      final String name = data['name'];
      final String preview = data['preview'];

      // 插入操作日志
      await _dbManager.insertRecord(userName,"${L10n.getStringWithoutContext('log_create_program')} :${name}");
      final int programId = await _dbManager.createProgram(
          groupId, modelId, name, preview, temItems);
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
      print('Error creating template: $e');
      print('Stack trace: $stackTrace');

      return Response.internalServerError(body: 'Error creating template: $e');
    }
  }

  /**
   * 更新节目
   */
  /**
   * 更新节目
   */
  Future<Response> updateProgram(Request request) async {
    print("updateProgram");
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final int programId = int.tryParse(data['id']) ?? 0;
      final int groupId = int.tryParse(data['groupId']) ?? 0;
      final int modelId = int.tryParse(data['modelId']) ?? 0;
      final String name = data['name'];
      final String preview = data['preview'];

      // 提取 items 列表
      final List<Map<String, dynamic>> temItems =
      (data['proItems'] as List).cast<Map<String, dynamic>>();

      // 调用数据库更新方法
      await _dbManager.updateProgram(
         programId,
         groupId,
         modelId,
         name,
         preview,
         temItems,
      );

      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': '更新成功',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    } catch (e, stackTrace) {
      print('Error updating program: $e');
      print('Stack trace: $stackTrace');

      return Response.internalServerError(
        body: 'Error updating program: $e',
      );
    }
  }



  /**
   * 获取所有节目或根据 groupId 获取节目列表
   */
  /**
   * 获取所有节目或根据 groupId 获取节目列表
   */
  Future<Response> getPrograms(Request request) async {
    print("getPrograms");
    final queryParams = request.url.queryParameters;
    final String? name = queryParams['name'];
    final String? groupIdString = queryParams['groupId'];
    final int page = int.tryParse(queryParams['page'] ?? '1') ?? 1; // 默认页码为 1
    // 从查询参数中获取每页数据量，默认 10，范围在 1 到 100 之间
    final int pageCount = (int.tryParse(queryParams['pageCount'] ?? '10') ?? 10).clamp(1, 100);

    try {
      List<ProgramData> programs;
      if (name != null && name.isNotEmpty) {
        // 如果 name 不为空，查找该名字对应的节目数据
        programs = await _dbManager.getProgramByName(name);
        // 按更新时间降序排序，取最新插入的那一个
        programs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        programs = programs.take(1).toList();
      } else if (groupIdString != null) {
        // 如果提供了 groupId，则根据 groupId 查询模板
        final int groupId = int.parse(groupIdString);
        print("getPrograms:groupId$groupId");
        programs = await _dbManager.getProgramsByGroupId(groupId);
      } else {
        // 否则获取所有模板
        programs = await _dbManager.getAllPrograms();
      }

      // 分页处理，使用 pageCount 替代硬编码的 pageSize
      final int startIndex = (page - 1) * pageCount;
      final List<ProgramData> paginatedPrograms = programs.skip(startIndex).take(pageCount).toList();

      final programList = paginatedPrograms.map((template) {
        return {
          'id': template.id,
          'groupId': template.groupId,
          'modelId': template.modelId,
          'name': template.name,
          'preview': template.preview,
          'updateTime': template.updatedAt.toIso8601String().substring(0, 19).replaceAll('T', ' '),
        };
      }).toList();

      // 计算总记录数和总页数
      final int totalCount = programs.length;
      final int totalPages = (totalCount / pageCount).ceil();

      // 构建响应数据结构
      final responseData = {
        'programs': programList,
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
    } catch (e) {
      return Response.internalServerError(body: 'Error fetching templates: $e');
    }
  }

  //获取节目配置数据
  Future<Response> getProgramEditDataByProgramId(Request request) async {
    final queryParams = request.url.queryParameters;
    final String? programIdString = queryParams['id'];

    // 检查 programId 是否为 null 或空字符串
    if (programIdString == null || programIdString.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '-1',
          'message': '缺少节目 ID',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }

    // 尝试将 programId 转换为整数
    final int? programId = int.tryParse(programIdString);
    if (programId == null) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '-1',
          'message': '无效的节目 ID',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }

    try {
      // 从数据库获取节目下的 item 数据
      final List<ProgramItem> programItems = await _dbManager.getProgramItemsByProgramId(programId);

      // 将 ProgramItem 对象转换为 Map 列表
      final List<Map<String, dynamic>> itemList = programItems.map((item) {
        return {
          'id': item.id,
          'programId': item.programId,
          'itemsId': item.itemsId,
          'url': item.url,
          // 可按需添加更多字段
        };
      }).toList();

      // 构建响应数据结构
      final responseData = {
        'programItems': itemList,
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
    } catch (e, stackTrace) {
      // 打印堆栈跟踪信息
      print('Error fetching program items: $e');
      print('Stack trace: $stackTrace');

      return Response.internalServerError(body: 'Error fetching program items: $e');
    }
  }

  /**
   * 批量删除节目
   */
  Future<Response> deletePrograms(Request request) async {
    final queryParams = request.url.queryParameters;
    final String? username = queryParams['userName'];
    final String? deleteId = queryParams['ids'];
    print("删除节目 ID: $deleteId");

    // 检查 deleteId 是否为 null 或空字符串
    if (deleteId == null || deleteId.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '-1',
          'message': '缺少节目 ID',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }

    // 将 deleteId 分割为 ID 列表
    final List<String> idList = deleteId.split(" ");
    print("删除节目 ID: $idList");
    for (String programId in idList) {
      final int? idInt = int.tryParse(programId);

      // 检查 idInt 是否为 null
      if (idInt == null) {
        print("无效的节目 ID: $programId");
        continue; // 跳过无效的 ID
      }
      if (username != null) {
        //根据节目Id查询这个节目的名称
        final program = await _dbManager.getProgramByProgramId(idInt);
        if (program!= null) {
          await _dbManager.insertRecord(username, "${L10n.getStringWithoutContext('log_delete_program')}:${program.name}");
        }
      }
      await _dbManager.deleteProgram(idInt);
    }

    // 返回删除结果
    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': '节目删除成功',
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
