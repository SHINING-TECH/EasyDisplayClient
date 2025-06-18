import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:snap_vison_client/config/app_config.dart';
import '../../database/database.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart';
import '../../util/SharedPreferencesUtils.dart';

/**
 * 推送操作通讯消息api
 */
class ApiCmd {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<Response> publishCmd(Request request) async {
    final payload = await request.readAsString();
    print('Received publishCmd: $payload');

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
    final cmdType = data['cmdType'];
    final terminalCodes = data['terminalCodes'];

    int cmdId = await _dbManager.addCmdInfo(cmdType);
    if (true) {
      CmdInfoData? cmdInfoData = await _dbManager.getLatestCmdInfo();
      if (cmdInfoData != null) {
        print("最近推送消息 pushType:${cmdInfoData.pushType} flag:${cmdInfoData.flag}");
        if (cmdInfoData.flag == 0) {
          if (cmdInfoData.pushType == AppConfig.restartProcess) {

          } else if (cmdInfoData.pushType == AppConfig.closeProcess){
            _dbManager.insertRecord(userName, "${L10n.getStringWithoutContext('log_publish_cmd')} :${L10n.getStringWithoutContext('log_publish_cmd_exit_app')}");
            _dbManager.updateCmdFlagById(cmdId);
            //延迟1s退出
            Future.delayed(const Duration(seconds: 1), () {
              exit(0);
            });
          }
        }
      }
    }

    if (true) {
      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': 'publish cmd Success',
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
          'message': '用户名或密码错误',
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