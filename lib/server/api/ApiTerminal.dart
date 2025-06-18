import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart'; // 假设您有一个数据库管理器
import '../../database/database.dart';
import '../../l10n/localization.dart'; // 假设您有一个数据库模型

class ApiTerminal {
  final DatabaseManager _dbManager = DatabaseManager();

  /**
   * 查询终端
   */
  Future<Response> getTerminals(Request request) async {
    // 从查询参数中获取 groupId 和 page
    final queryParams = request.url.queryParameters;
    final String? groupIdString = queryParams['groupId'];
    final int page = int.tryParse(queryParams['page'] ?? '1') ?? 1; // 默认页码为 1

    // 从数据库获取所有终端
    List<TerminalData> terminals;

    if (groupIdString != null) {
      final int groupId = int.parse(groupIdString);
      terminals = await _dbManager.getTerminalsByGroupId(groupId); // 根据 groupId 获取终端
    } else {
      terminals = await _dbManager.getAllTerminals(); // 获取所有终端
    }

    // 分页处理
    final int pageSize = 10; // 每页显示的终端数量
    final int startIndex = (page - 1) * pageSize;
    final List<TerminalData> paginatedTerminals = terminals.skip(startIndex).take(pageSize).toList();

    // 将终端转换为 JSON 格式
    final List<Map<String, dynamic>> terminalList = paginatedTerminals.map((terminal) {
      return {
        'id': terminal.id,
        'name': terminal.name,
        'terminalCode': terminal.terminalCode,
        'type': terminal.type,
        'password': terminal.pasWord, // 假设数据库字段名为 'password
        'resolution': terminal.resolution,
        'sversion': terminal.sversion,
        'version': terminal.version,
        'mac': terminal.mac,
        'status': terminal.status,
        'updateTime': terminal.updateTime,
        'lastControlMsg': terminal.lastControlMsg,
        'groupId': terminal.groupId,
      };
    }).toList();

    // 构建响应数据结构
    final responseData = {
      'terminals': terminalList,
      'pages': {
        'count': (terminals.length / pageSize).ceil(), // 总页数
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
   * 添加终端
   */
  Future<Response> addTerminal(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final String name = data['name'];
      final String terminalCode = data['terminalCode'];
      final String type = data['type'];
      final String resolution = data['resolution'];
      final String sversion = data['sversion'];
      final String version = data['version'];
      final String mac = data['mac'];
      final String status = data['status'];
      final String updateTime = data['updateTime'];
      final String lastControlMsg = data['lastControlMsg'];
      final int groupId = data['groupId'];

      final int id = await _dbManager.addTerminals(
        // name,
        // terminalCode,
        // type,
        // resolution,
        // sversion,
        // version,
        // mac,
        // status,
        // updateTime,
        // lastControlMsg,
        // groupId,
      );

      return Response.ok(
        jsonEncode({'code': '0', 'message': 'Terminal added successfully', 'id': id}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: 'Error adding terminal: $e');
    }
  }

  /**
   * 修改终端参数
   */
  Future<Response> modifyTerminalParams(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final String userName = data['userName'];
      final String terminalCode = data['terminalCode'];
      final String psw = data['psw'];
      final String name = data['name'];
      print('modifyTerminalParams => terminalCode: $terminalCode psw: $psw name: $name');

      // 写入操作日志
      _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_modify_ter_params')} :${terminalCode}");

      await _dbManager.modifyTerminalParams(
        terminalCode,
        name,
        psw,
      );

      return Response.ok(
        jsonEncode({'code': '0', 'message': 'Terminal parameters modified successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: 'Error modifying terminal parameters: $e');
    }
  }

  // /**
  //  * 更新终端
  //  */
  // Future<Response> updateTerminal(Request request) async {
  //   try {
  //     final body = await request.readAsString();
  //     final data = jsonDecode(body);
  //
  //     final int id = data['id'];
  //     final String name = data['name'];
  //     final String terminalCode = data['terminalCode'];
  //     final String type = data['type'];
  //     final String resolution = data['resolution'];
  //     final String sversion = data['sversion'];
  //     final String version = data['version'];
  //     final String mac = data['mac'];
  //     final String status = data['status'];
  //     final String updateTime = data['updateTime'];
  //     final String lastControlMsg = data['lastControlMsg'];
  //     final int groupId = data['groupId'];
  //
  //     await _dbManager.updateTerminal(
  //       id,
  //       name,
  //       terminalCode,
  //       type,
  //       resolution,
  //       sversion,
  //       version,
  //       mac,
  //       status,
  //       updateTime,
  //       lastControlMsg,
  //       groupId,
  //     );
  //
  //     return Response.ok(
  //       jsonEncode({'code': '0', 'message': 'Terminal updated successfully'}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //   } catch (e) {
  //     return Response.internalServerError(body: 'Error updating terminal: $e');
  //   }
  // }
  //
  // /**
  //  * 删除终端
  //  */
  // Future<Response> deleteTerminal(Request request) async {
  //   final queryParams = request.url.queryParameters;
  //   final String? idString = queryParams['id'];
  //
  //   if (idString == null) {
  //     return Response.badRequest(body: 'Missing terminal ID');
  //   }
  //
  //   try {
  //     final int id = int.parse(idString);
  //     await _dbManager.deleteTerminal(id);
  //
  //     return Response.ok(
  //       jsonEncode({'code': '0', 'message': 'Terminal deleted successfully'}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //   } catch (e) {
  //     return Response.internalServerError(body: 'Error deleting terminal: $e');
  //   }
  // }

  // 提取CORS headers为一个方法，避免重复代码
  Map<String, String> _getCorsHeaders() => {
    'Access-Control-Allow-Origin': 'http://localhost:8666',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };
}