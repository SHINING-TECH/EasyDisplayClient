import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart';

/**
 * 登录api
 */
class Login {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<Response> login(Request request) async {
    final payload = await request.readAsString();
    print('Received payload: $payload');

    Map<String, dynamic> data;
    try {
      data = jsonDecode(payload);
    } catch (e) {
      return Response.badRequest(
        body: 'Invalid JSON format',
        headers: _getCorsHeaders(),
      );
    }

    final username = data['username'];
    final password = data['password'];

    print('Username: $username, Password: $password');

    // 使用数据库验证用户登录
    final isValid = await _dbManager.login(username, password);

    if (isValid) {
      _dbManager.insertRecord(username, "${L10n.getStringWithoutContext('log_login')}");
      return Response.ok(
        jsonEncode({
          'code': '0',
          'message': 'Login Success',
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
          'message': 'Incorrect password'
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