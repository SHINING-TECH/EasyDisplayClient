import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';
import '../../database/database.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart'; // 引入数据库管理器

class ApiTemplate {
  final DatabaseManager _dbManager = DatabaseManager();

  /**
   * 获取所有模板或根据 groupId 获取模板列表
   */
  Future<Response> getTemplates(Request request) async {
    final queryParams = request.url.queryParameters;
    final String? groupIdString = queryParams['groupId'];
    final int page = int.tryParse(queryParams['pageNo'] ?? '1') ?? 1; // 默认页码为 1
    // 从查询参数中获取每页数据量，默认 10，范围在 1 到 100 之间
    final int pageCount = (int.tryParse(queryParams['pageCount'] ?? '10') ?? 10).clamp(1, 100);

    try {
      List<Template> templates;

      if (groupIdString != null) {
        // 如果提供了 groupId，则根据 groupId 查询模板
        final int groupId = int.parse(groupIdString);
        templates = await _dbManager.getTemplatesByGroupId(groupId);
      } else {
        // 否则获取所有模板
        templates = await _dbManager.getAllTemplates();
      }

      // 分页处理，使用 pageCount 替代硬编码的 pageSize
      final int startIndex = (page - 1) * pageCount;
      final List<Template> paginatedTemplates = templates.skip(startIndex).take(pageCount).toList();

      // 计算总页数
      final int totalPages = (templates.length / pageCount).ceil();

      final templateList = paginatedTemplates.map((template) {
        return {
          'id': template.id,
          'body': template.body,
          'creator': template.creator,
          'desc': template.desc,
          'groupId': template.groupId,
          'resolution': template.resolution,
          'width': template.width,
          'height': template.height,
          'name': template.name,
          'preview': template.preview,
          'terminalType': template.terminalType,
          'type': template.type,
          'updateTime': template.updatedAt.toIso8601String().substring(0, 19).replaceAll('T', ' '), // 转换为字符串
        };
      }).toList();

      // 构建响应数据结构
      final responseData = {
        'templates': templateList,
        'pages': {
          'count': totalPages, // 总页数
          'pageSize': pageCount, // 每页数量
          'currentPage': page, // 当前页码
          'totalItems': templates.length, // 总模板数量
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

  /**
   * 新建模板
   */
  Future<Response> newTemplate(Request request) async {
    try {
      print('新建模板'); // 打印请求信息
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final String htmlBody = data['body'];
      final String creator = data['creator'];
      final List<TemplateItemsCompanion> temItems = (data['temItems'] as List).map((item) =>
          TemplateItemsCompanion.insert(
        id: item['id'],
        backGround: Value(item['backGround']),
        resourceId: Value(item['resId'] ?? ''),
        height: (item['height'] as num).toDouble(), // 确保转换为 double
        name: item['name'],
        type: item['type'],
        width: (item['width'] as num).toDouble(), // 确保转换为 double
        x: (item['x'] as num).toInt(),
        y: (item['y'] as num).toInt(),
        zIndex:(item['zIndex'] as num).toInt(),
      )).toList();

      final int groupId =(data['groupId'] is String) ? int.tryParse(data['groupId']) ?? 0 : (data['groupId'] as num).toInt();
      final String name = data['name'];
      final String type = data['type'];
      final int width = (data['width'] is String) ? int.tryParse(data['width']) ?? 0 : (data['width'] as num).toInt(); // 转换为 double
      final int height = (data['height'] is String) ? int.tryParse(data['height']) ?? 0 : (data['height'] as num).toInt(); // 转换为 double
      final String preview = data['preview'];
      final String terminalType = data['terminalType'];
      final String desc = data['desc'];

      _dbManager.insertRecord(creator, "${L10n.getStringWithoutContext('log_create_template')} :${name}");

      final int templateId = await _dbManager.createTemplate(
        htmlBody,
        creator,
        temItems,
        groupId,
        name,
        type,
        width,
        height,
        preview,
        terminalType,
        desc,
      );
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
   * 更新模板
   */
  Future<Response> updateTemplate(Request request) async {
    try {
      print("更新模板");
      final body = await request.readAsString();
      final data = jsonDecode(body);

      // Get the template ID to update
      final int templateId = data['id'];

      final String htmlBody = data['body'];
      final String creator = data['creator'];
      final List<TemplateItemsCompanion> temItems = (data['temItems'] as List).map((item) =>
          TemplateItemsCompanion.insert(
            id: (item['id'] is int) ? item['id'].toString() : item['id'].toString(),
            backGround: Value(item['backGround']),
            resourceId: Value(item['resId'] ?? ''),
            height: (item['height'] is String) ? (num.tryParse(item['height']) ?? 0.0).toDouble() : (item['height'] as num).toDouble(),
            name: item['name'],
            type: item['type'],
            width: (item['width'] is String) ? (num.tryParse(item['width']) ?? 0.0).toDouble() : (item['width'] as num).toDouble(),
            x: (item['x'] is String) ? (num.tryParse(item['x']) ?? 0).toInt() : (item['x'] as num).toInt(),
            // 处理 y，若为 String 类型则尝试转换为 num，转换失败使用 0
            y: (item['y'] is String) ? (num.tryParse(item['y']) ?? 0).toInt() : (item['y'] as num).toInt(),
            zIndex: (item['zIndex'] is String) ? (num.tryParse(item['zIndex']) ?? 0).toInt() : (item['zIndex'] as num).toInt(),
          )).toList();

      final int groupId =(data['groupId'] is String) ? int.tryParse(data['groupId']) ?? 0 : (data['groupId'] as num).toInt();
      final String name = data['name'];
      final String type = data['type'];
      final int width = (data['width'] is String) ? int.tryParse(data['width']) ?? 0 : (data['width'] as num).toInt();
      final int height = (data['height'] is String) ? int.tryParse(data['height']) ?? 0 : (data['height'] as num).toInt();
      final String preview = data['preview'];
      final String terminalType = data['terminalType'];
      final String desc = data['desc'];

      _dbManager.insertRecord(creator, "${L10n.getStringWithoutContext('log_update_template')} :${name}");
      // Call the database manager to update the template
      await _dbManager.updateTemplate(
        templateId,
        htmlBody,
        creator,
        temItems,
        groupId,
        name,
        type,
        width,
        height,
        preview,
        terminalType,
        desc,
      );
      print("更新模板完成");
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
      // Print stack trace information
      print('Error updating template: $e');
      print('Stack trace: $stackTrace');

      return Response.internalServerError(body: 'Error updating template: $e');
    }
  }


  /**
   * 删除模板
   */
  Future<Response> deleteTemplate(Request request) async {
    final queryParams = request.url.queryParameters;
    final userName = queryParams['userName']?? '';
    final String? deleteIds = queryParams['ids'];

    // 检查 deleteIds 是否为 null 或空字符串
    if (deleteIds == null || deleteIds.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'code': '-1',
          'message': '缺少模板 ID',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }

    // 将 deleteIds 分割为 ID 列表
    final List<String> idList = deleteIds.split(" ");
    List<int> deletedIds = []; // 存储已删除的模板 ID
    List<String> failedIds = []; // 存储删除失败的 ID

    for (String templateIdStr in idList) {
      final int? templateId = int.tryParse(templateIdStr);

      // 检查 templateId 是否为 null
      if (templateId == null) {
        print("无效的模板 ID: $templateIdStr");
        failedIds.add(templateIdStr);
        continue; // 跳过无效的 ID
      }

      try {
        print("删除模板 ID: $templateId");
        _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_delete_template')}:${templateId}");
        await _dbManager.deleteTemplateById(templateId);
        deletedIds.add(templateId);
        print("模板 ID $templateId 删除成功");
      } catch (e) {
        print("删除模板 ID $templateId 时出错: $e");
        failedIds.add(templateIdStr);
      }
    }

    // 构建响应消息
    String message = '模板删除成功';
    if (failedIds.isNotEmpty) {
      message = '部分模板删除失败，失败的 ID: ${failedIds.join(", ")}';
    }

    // 返回删除结果
    return Response.ok(
      jsonEncode({
        'code': '0',
        'message': message,
        'deletedIds': deletedIds, // 返回已删除的模板 ID
        'failedIds': failedIds, // 返回删除失败的 ID
      }),
      headers: {
        'Content-Type': 'application/json',
        ..._getCorsHeaders(),
      },
    );
  }


  /**
   * 根据 ID 获取模板-详细信息包含item
   */
  Future<Response> getTemplateById(Request request) async {
    final queryParams = request.url.queryParameters;
    final String? idString = queryParams['id'];

    if (idString == null) {
      return Response.ok(
        jsonEncode({
          'code': '-1',
          'message': '请传递查询id',
        }),
        headers: {
          'Content-Type': 'application/json',
          ..._getCorsHeaders(),
        },
      );
    }

    try {
      final int id = int.parse(idString);
      final template = await _dbManager.getTemplateById(id); // 获取模板

      if (template == null) {
        return Response.ok(
          jsonEncode({
            'code': '0',
            'message': '无此模板',
          }),
          headers: {
            'Content-Type': 'application/json',
            ..._getCorsHeaders(),
          },
        );
      }

      // 获取与模板相关的 temItems
      final List<TemplateItem> temItems = await _dbManager.getTemplateItemsByTemplateId(id);

      // 构建返回的数据结构
      final templateData = {
        'id': template.id,
        'body': template.body,
        'creator': template.creator,
        'desc': template.desc,
        'groupId': template.groupId,
        'resolution': template.resolution,
        'width': template.width,
        'height': template.height,
        'name': template.name,
        'preview': template.preview,
        'terminalType': template.terminalType,
        'type': template.type,
        'temItems': temItems.map((item) {
          return {
            'backGround': item.backGround,
            'resId':item.resourceId,
            'height': item.height,
            'id': item.id,
            'name': item.name,
            'type': item.type,
            'width': item.width,
            'x': item.x,
            'y': item.y,
            'zIndex': item.zIndex,
          };
        }).toList(),
      };

      // 构建响应数据结构
      final responseData = {
        'templates': [templateData],
      };

      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': 'Template retrieved successfully',
          'data': responseData, // 将模板数据放入 templates 数组中
          'pages': {
            'count': 1, // 假设只有一页
          },
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: 'Error fetching template: $e');
    }
  }

  // 提取CORS headers为一个方法，避免重复代码
  Map<String, String> _getCorsHeaders() => {
    'Access-Control-Allow-Origin': 'http://localhost:8666',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };
}