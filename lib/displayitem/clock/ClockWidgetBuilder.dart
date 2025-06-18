import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';

import '../../database/database.dart';
import '../BaseDisplayWidget.dart';
import 'ClockItemData.dart';

class ClockWidgetBuilder extends BaseDisplayWidget {
  @override
  Future<Widget> buildWidget(int programId, Map<String, dynamic> item) async {
    String itemID = item['id'];
    print("构建图片区域显示组件 模板区域id: ${itemID}");
    ProgramItem? programItemData = await queryProgramItem(programId, itemID);
    if (programItemData == null)
      return handleEmptyProgramItem('Abnormal Time area');
    ClockItemData? clockItemData = parseSingleJsonData<ClockItemData>(
      programItemData.url ?? "[]",
      (json) => ClockItemData.fromJson(json),
    );
    print("查询到的节目中这个模板图片区域的配置:${programItemData.toJson()}");
    if (clockItemData == null)
      return handleEmptyItemList('No Clock Data found');
    return await _buildClock(clockItemData);
  }

  Future<Widget> _buildClock(ClockItemData clockConfigData) async {
    print("timeArea: ${clockConfigData.timeArea}");
    // 默认 UTC+8
    final timeArea = clockConfigData.timeArea ?? 'UTC+8';
    // 正则匹配时区字符串
    final match = RegExp(r'^UTC([+-])(\d{1,2})$').firstMatch(timeArea);
    int offset = 8; // 默认偏移
    String displayLabel = timeArea;
    if (match != null) {
      final sign = match.group(1);
      final hours = int.parse(match.group(2)!);
      offset = sign == '+' ? hours : -hours;
    }
    final nowUtc = DateTime.now().toUtc();
    final localTime = nowUtc.add(Duration(hours: offset));
    return AnalogClock(
      dateTime: localTime,
      isKeepTime: true,
      child: Align(
        alignment: const FractionalOffset(0.5, 0.75),
        //child: Text(timeArea), // 显示 "UTC+8"、"UTC-5" 等
      ),
    );
  }

  @override
  void dispose() {
    // 不需要释放资源
  }
}
