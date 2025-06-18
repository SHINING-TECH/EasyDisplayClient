import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/database_manager.dart';
import '../../l10n/localization.dart';

/**
 * 用户api
 * 修改密码
 * 重置密码
 */
class ApiUser {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<Response> setPsw(Request request) async {
    // 读取请求体内容
    final payload = await request.readAsString();
    print('Received payload: $payload');

    Map<String, dynamic> data;
    try {
      // 解析 JSON 数据
      data = jsonDecode(payload);
    } catch (e) {
      // 若 JSON 格式错误，返回 400 状态码
      return Response.badRequest(
        body: 'Invalid JSON format',
        headers: _getCorsHeaders(),
      );
    }

    // 从解析后的数据中提取所需字段
    final username = data['userName'] is int ? (data['userName'] as int).toString() : data['userName'] as String?;
    final oldPassword = data['oldPassword'] is int ? (data['oldPassword'] as int).toString() : data['oldPassword'] as String?;
    final newPassword = data['newPassword'] is int ? (data['newPassword'] as int).toString() : data['newPassword'] as String?;
    final question = data['question'] is int ? (data['question'] as int).toString() : data['question'] as String?;
    final answer = data['answer'] is int ? (data['answer'] as int).toString() : data['answer'] as String?;


    // 打印提取的字段值
    print('Extracted username: $username');
    print('Extracted oldPassword: $oldPassword');
    print('Extracted newPassword: $newPassword');
    print('Extracted question: $question');
    print('Extracted answer: $answer');
    // 检查必要字段是否存在
    if (username == null || oldPassword == null || newPassword == null || question == null || answer == null) {
      return Response.badRequest(
        body: 'Missing required fields',
        headers: _getCorsHeaders(),
      );
    }

    try {
      //插入操作日志
      _dbManager.insertRecord(username, "${L10n.getStringWithoutContext('log_change_psw')}");
      // 调用数据库方法修改密码
      final result = await _dbManager.changePassword(username, oldPassword, newPassword, question, answer);
      if (result == "success") {
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
        // 修改失败，返回 400 状态码
        return Response.ok(
          jsonEncode({
            'code': '-1',
            'message': result,
          }),
          headers: {
            'Content-Type': 'application/json',
            ..._getCorsHeaders(),
          },
        );
      }
    } catch (e) {
      // 处理异常，返回 500 状态码
      print('Error changing password: $e');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Internal server error'}),
        headers: {
          ..._getCorsHeaders(),
          'Content-Type': 'application/json',
        },
      );
    }
  }

  // 新增：获取用户信息的 API 函数
  Future<Response> getUserInfo(Request request) async {
    // 读取请求体内容
    final payload = await request.readAsString();
    print('Received payload for getUserInfo: $payload');

    Map<String, dynamic> data;
    try {
      // 解析 JSON 数据
      data = jsonDecode(payload);
    } catch (e) {
      // 若 JSON 格式错误，返回 400 状态码
      return Response.badRequest(
        body: 'Invalid JSON format',
        headers: _getCorsHeaders(),
      );
    }

    // 从解析后的数据中提取用户名
    final username = data['userName'] is int ? (data['userName'] as int).toString()
        : data['userName'] as String?;

    // 打印提取的用户名
    print('Extracted username for getUserInfo: $username');

    // 检查用户名是否存在
    if (username == null) {
      return Response.badRequest(
        body: 'Missing required field: userName',
        headers: _getCorsHeaders(),
      );
    }

    try {
      // 调用数据库方法获取用户信息
      final result = await _dbManager.queryUserInfo(username);
      if (result!=null) {
        // 获取失败
        return Response.ok(
          jsonEncode({
            'code': '0',
            'message': 'Get user info success',
            'data': {
              'id': result.id,
              'username': result.username,
              'question': result.securityQuestion
            }
          }),
          headers: {
            'Content-Type': 'application/json',
           ..._getCorsHeaders(),
          },
        );
      } else {
        return Response.ok(
          jsonEncode({
            'code': '1',
            'message': 'user is empty',
          }),
          headers: {
            'Content-Type': 'application/json',
            ..._getCorsHeaders(),
          },
        );
      }
    } catch (e) {
      // 处理异常，返回 500 状态码
      print('Error getting user info: $e');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Internal server error'}),
        headers: {
          ..._getCorsHeaders(),
          'Content-Type': 'application/json',
        },
      );
    }
  }

// 重置密码的 API 函数
  Future<Response> resetPassword(Request request) async {
    // 读取请求体内容
    final payload = await request.readAsString();
    print('Received payload for resetPassword: $payload');

    Map<String, dynamic> data;
    try {
      // 解析 JSON 数据
      data = jsonDecode(payload);
    } catch (e) {
      // 若 JSON 格式错误，返回 400 状态码
      return Response.badRequest(
        body: 'Invalid JSON format',
        headers: _getCorsHeaders(),
      );
    }

    // 从解析后的数据中提取用户名
    final username = data['userName'] is int ? (data['userName'] as int).toString() : data['userName'] as String?;
    // 从解析后的数据中提取用户名
    final answer = data['answer'] != null
        ? (data['answer'] is int ? (data['answer'] as int).toString() : data['answer'] as String)
        : "";
    // 打印提取的用户名
    print('Extracted username for resetPassword: $username');

    // 检查用户名是否存在
    if (username == null) {
      return Response.badRequest(
        body: 'Missing required field: userName',
        headers: _getCorsHeaders(),
      );
    }

    try {
      //插入操作日志
      _dbManager.insertRecord(username, "${L10n.getStringWithoutContext('log_reset_psw')}");
      // 调用数据库方法重置密码
      final result = await _dbManager.resetPsw(username,answer);
      print('Reset password result: $result');
      if (result == "ok") {
        return Response.ok(
          jsonEncode({
            'code': '0',
            'message': 'Password reset successfully',
          }),
          headers: {
            'Content-Type': 'application/json',
            ..._getCorsHeaders(),
          },
        );
      } else {
        // 重置失败，返回 400 状态码
        return Response.ok(
          jsonEncode({
            'code': '-1',
            'message': result,
          }),
          headers: {
            'Content-Type': 'application/json',
            ..._getCorsHeaders(),
          },
        );
      }
    } catch (e) {
      // 处理异常，返回 500 状态码
      print('Error resetting password: $e');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Internal server error'}),
        headers: {
          ..._getCorsHeaders(),
          'Content-Type': 'application/json',
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