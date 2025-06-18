import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/database_manager.dart';

abstract class BaseDisplayWidget {
  final DatabaseManager _dbManager = DatabaseManager();

  // 抽象方法，查询节目配置信息
  @override
  Future<ProgramItem?> queryProgramItem(int programId, String itemID) async {
    return await _dbManager.getProgramItemByProgramIdAndItemId(programId, itemID);
  }

  //处理节目数据为空的情况
  @override
  Widget handleEmptyProgramItem(String errorText) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text(
        errorText,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  //处理区域内容配置为空的情况
  @override
  Widget handleEmptyItemList(String errorText) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text(
        errorText,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  List<T> parseJsonData<T>(String jsonStr, T Function(Map<String, dynamic>) fromJson) {
    List<T> itemList = [];
    try {
      final jsonList = json.decode(jsonStr) as List<dynamic>;
      itemList = jsonList.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Failed to parse JSON: $e");
    }
    return itemList;
  }

  @override
  T? parseSingleJsonData<T>(String jsonStr, T Function(Map<String, dynamic>) fromJson) {
    try {
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      print("Failed to parse single JSON: $e");
      return null;
    }
  }

  // 抽象方法，主动释放资源
  void dispose();

}
