import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:snap_vison_client/displayitem/timeTxt/TimeTextItemData.dart';
import '../../database/database.dart';
import '../BaseDisplayWidget.dart';

/// 时间文字区域显示组件
class TimeTextWidgetBuilder extends BaseDisplayWidget {
  Timer? _timer;
  late ValueNotifier<DateTime> _currentTime;

  TimeTextWidgetBuilder() {
    _currentTime = ValueNotifier(DateTime.now());
  }

  @override
  Future<Widget> buildWidget(int programId, Map<String, dynamic> item) async {
    String itemID = item['id'];
    ProgramItem? programItemData = await queryProgramItem(programId, itemID);
    if (programItemData == null) return handleEmptyProgramItem('Abnormal Time area');

    TimeTextItemData? timeTextItemData = parseSingleJsonData<TimeTextItemData>(
      programItemData.url ?? "[]", (json) => TimeTextItemData.fromJson(json),
    );

    if (timeTextItemData == null) return handleEmptyItemList('No Time Data found');

    return buildTimeTxt(timeTextItemData);
  }

  Future<Widget> buildTimeTxt(TimeTextItemData timeTextData) async {
    // 初始化时区数据库
    tz.initializeTimeZones();
    print("timeArea ${timeTextData.timeArea}");

    tz.Location getTimeZoneLocation(String timeArea) {
      final utcOffsetToLocation = {
        '-12': 'Pacific/Funafuti',
        '-11': 'Pacific/Midway',
        '-10': 'Pacific/Honolulu',
        '-9': 'America/Anchorage',
        '-8': 'America/Los_Angeles',
        '-7': 'America/Denver',
        '-6': 'America/Chicago',
        '-5': 'America/New_York',
        '-4': 'America/Santiago',
        '-3': 'America/Argentina/Buenos_Aires',
        '-2': 'Atlantic/South_Georgia',
        '-1': 'Atlantic/Azores',
        '+0': 'Europe/London',
        '+1': 'Europe/Berlin',
        '+2': 'Europe/Athens',
        '+3': 'Europe/Moscow',
        '+4': 'Asia/Dubai',
        '+5': 'Asia/Karachi',
        '+6': 'Asia/Dhaka',
        '+7': 'Asia/Bangkok',
        '+8': 'Asia/Shanghai',
        '+9': 'Asia/Tokyo',
        '+10': 'Australia/Sydney',
        '+11': 'Pacific/Noumea',
        '+12': 'Pacific/Auckland',
        '+13': 'Pacific/Tongatapu',
        '+14': 'Pacific/Kiritimati',
      };
      if (timeArea.startsWith('UTC')) {
        try {
          final offsetStr = timeArea.replaceFirst('UTC', '').trim();
          if (utcOffsetToLocation.containsKey(offsetStr)) {
            return tz.getLocation(utcOffsetToLocation[offsetStr]!);
          }
        } catch (e) {
          print("Error converting UTC offset to timezone: $e");
        }
      }
      // 如果转换失败或不是 UTC 格式，直接使用原输入
      try {
        return tz.getLocation(timeArea);
      } catch (e) {
        print("Error getting timezone location: $e");
        // 默认返回上海时区
        return tz.getLocation('Asia/Shanghai');
      }
    }

    final location = getTimeZoneLocation(timeTextData.timeArea ?? 'UTC+8');


    // 每秒更新时间
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime.value = tz.TZDateTime.now(location);
    });

    return ValueListenableBuilder<DateTime>(
      valueListenable: _currentTime,
      builder: (context, now, child) {
        //timeTextData.timeFormat ??
        final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        return Container(
          color: parseColor(timeTextData.textBGColor),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                formatted,
                style: TextStyle(
                  color: parseColor(timeTextData.textColor),
                  fontSize: double.tryParse(timeTextData.textFontSize.toString()) ?? 20,
                  fontWeight: parseFontWeight(timeTextData.textWeight),
                  fontStyle: parseFontStyle(timeTextData.textStyle),
                  decoration: parseUnderline(timeTextData.textUnderline),
                ),
                textAlign: parseTextAlign(timeTextData.align),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    print("时间文字区域销毁!");
    _timer?.cancel();
    _currentTime.dispose();
  }

  // ---------- 样式辅助方法 ----------

  Color parseColor(String colorStr) {
    if (colorStr.isEmpty) return Colors.black;
    if (colorStr.startsWith('rgba')) {
      try {
        final parts = colorStr.substring(5, colorStr.length - 1).split(',');
        if (parts.length == 4) {
          final r = int.parse(parts[0].trim());
          final g = int.parse(parts[1].trim());
          final b = int.parse(parts[2].trim());
          final opacity = double.parse(parts[3].trim());
          return Color.fromRGBO(r, g, b, opacity);
        }
      } catch (e) {
        print("Error parsing rgba color: $e");
      }
    }
    colorStr = colorStr.replaceAll("#", "");
    if (colorStr.length == 6) {
      colorStr = "FF$colorStr";
    } else if (colorStr.length == 8) {
      final alpha = colorStr.substring(6, 8);
      final rgb = colorStr.substring(0, 6);
      colorStr = alpha + rgb;
    }
    try {
      return Color(int.parse(colorStr, radix: 16));
    } catch (e) {
      print("Error parsing hex color: $e");
      return Colors.black;
    }
  }

  FontWeight parseFontWeight(String weight) {
    switch (weight.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  FontStyle parseFontStyle(String italic) {
    return italic.toLowerCase() == 'italic' ? FontStyle.italic : FontStyle.normal;
  }

  TextDecoration parseUnderline(String underline) {
    return underline.toLowerCase() == 'underline' ? TextDecoration.underline : TextDecoration.none;
  }

  TextAlign parseTextAlign(String align) {
    switch (align.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      default:
        return TextAlign.center;
    }
  }
}
