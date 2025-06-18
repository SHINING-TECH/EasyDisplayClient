// ... existing code ...

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../database/database.dart';
import '../../database/database_manager.dart';
import 'dart:convert';

import 'ScrollTextItemData.dart';

/**
 * 滚动文字区域显示组件
 */
class ScrollTextWidgetBuilder {
  static Future<Widget> buildScrollTextWidget(
      int programId, Map<String, dynamic> item) async {
    final DatabaseManager _dbManager = DatabaseManager();
    String itemID = item['id'];
    print("构建文字区域显示组件 模板区域id: ${itemID}");
    try {
      //根据programID和模板区域id查询节目中这个模板区域的配置
      ProgramItem? programItemData = await _dbManager
          .getProgramItemByProgramIdAndItemId(programId, itemID);
      print("查询到的节目中这个模板区域的配置:${programItemData?.toJson()}");
      String configData = programItemData?.url ?? "";
      ScrollTextItemData? textItemData;
      try {
        if (configData.isNotEmpty) {
          Map<String, dynamic> jsonData = json.decode(configData);
          textItemData = ScrollTextItemData.fromJson(jsonData);
        }
      } catch (e) {
        print("Error decoding configData: $e");
      }

      if (programItemData == null || textItemData == null) {
        // 当programItemData为空或解析失败时，显示错误信息
        return Container(
          color: Colors.black, // 设置背景色为黑色
          alignment: Alignment.center, // 文字居中显示
          child: Text(
            'Abnormal textview area',
            style: TextStyle(color: Colors.red),
          ),
        );
      }

      // 解析颜色
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
          // 6位十六进制颜色，添加默认透明度 FF（完全不透明）
          colorStr = "FF$colorStr";
        } else if (colorStr.length == 8) {
          // 8位十六进制颜色，调整顺序为 AARRGGBB
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

      // 解析字体粗细
      FontWeight parseFontWeight(String bold) {
        switch (bold) {
          case 'bold':
            return FontWeight.bold;
          default:
            return FontWeight.normal;
        }
      }

      // 解析字体样式
      FontStyle parseFontStyle(String italic) {
        switch (italic) {
          case 'italic':
            return FontStyle.italic;
          default:
            return FontStyle.normal;
        }
      }

      // 解析下划线
      TextDecoration parseUnderline(String underline) {
        switch (underline) {
          case 'underline':
            return TextDecoration.underline;
          default:
            return TextDecoration.none;
        }
      }

      //滚动方向
      int scrollDirection = int.tryParse(textItemData.scrollDirection.toString()) ?? 0;
      print("滚动方向:${scrollDirection}");
      Axis _scrollAxis = Axis.vertical;
      TextDirection _textDirection = TextDirection.ltr;

      // Determine the scroll axis and text direction based on scrollDirection
      switch (scrollDirection) {
        case 0:
        // Left to right
          _scrollAxis = Axis.horizontal;
          _textDirection = TextDirection.ltr;
          break;
        case 1:
        // Right to left
          _scrollAxis = Axis.horizontal;
          _textDirection = TextDirection.rtl;
          break;
        case 2:
        // Bottom to top
          _scrollAxis = Axis.vertical;
          _textDirection = TextDirection.rtl;
          break;
        case 3:
        // Top to bottom
          _scrollAxis = Axis.vertical;
          _textDirection = TextDirection.ltr;
          break;
        default:
        // Default to left to right
          _scrollAxis = Axis.horizontal;
          _textDirection = TextDirection.ltr;
      }

      //滚动速度
      // Function to parse scroll speed
      double parseScrollSpeed(int speed) {
        switch (speed) {
          case 0: // Slow
            return 50.0;
          case 1: // Medium
            return 100.0;
          case 2: // Fast
            return 200.0;
          default: // Default to medium
            return 100.0;
        }
      }


      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double blankSpaceValue = _scrollAxis == Axis.horizontal
              ? constraints.maxWidth
              : constraints.maxHeight;

          return Container(
            color:  parseColor(textItemData!.textBGColor),
            child: Center(
              child: Marquee(
                text: textItemData!.textContent,
                style: TextStyle(
                  color: parseColor(textItemData!.textColor),
                  fontSize: double.tryParse(textItemData.textFontSize.toString()) ?? 20,
                  fontFamily: textItemData.textFontFamily,
                  fontWeight: parseFontWeight(textItemData.textWeight),
                  fontStyle: parseFontStyle(textItemData.textStyle),
                  decoration: parseUnderline(textItemData.textUnderline),
                ),
                scrollAxis: _scrollAxis,//文本滚动的方向 (横向还是竖向)
                textDirection: _textDirection,//方向
                crossAxisAlignment: CrossAxisAlignment.center,//沿滚动方向的垂直轴对齐文本
                blankSpace: blankSpaceValue,//滚动文字间距
                velocity: parseScrollSpeed(textItemData.scrollSpeed),//设置文本滚动的速度
                startAfter: Duration.zero,
                pauseAfterRound:  Duration.zero,//单次滚动完成后暂停时长
                showFadingOnlyWhenScrolling: false,//如果设置为 true，则仅在文本滚动时显示文本边缘的渐隐效果。
                //fadingEdgeStartFraction: 0.1,//指定在组件宽度（或高度，取决于滚动方向）的起始位置开始显示渐隐效果的比例。值为 0.1 表示渐隐效果从组件宽度的 10% 处开始
                //fadingEdgeEndFraction: 0.1,//指定在组件宽度（或高度，取决于滚动方向）的结束位置开始显示渐隐效果的比例。值为 0.1 表示渐隐效果从组件宽度的 90% 处开始。
                //numberOfRounds: 1,//指定文本在组件中滚动的轮数。滚动 3 轮后，滚动将停止。
                startPadding: 0,//在文本开始滚动前，在文本起始位置添加的内边距（以逻辑像素为单位
                accelerationDuration: Duration(seconds: 0),//设置文本从静止加速到滚动速度所需的时长。在此示例中，加速过程持续 1 秒。
                accelerationCurve: Curves.linear,//定义文本加速的曲线。Curves.linear 表示文本以恒定速率加速。
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Error in buildTextWidget: $e");
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Text(
          'Error occurred while building text widget',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
