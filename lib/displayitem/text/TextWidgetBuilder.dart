import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../database/database_manager.dart';
import 'TextItemData.dart';
import 'dart:convert';
import '../BaseDisplayWidget.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // 导入 animated_text_kit 库


/**
 * 文字区域显示组件
 */
class TextWidgetBuilder extends BaseDisplayWidget {
  @override
  Future<Widget> buildWidget(int programId, Map<String, dynamic> item) async {
    final DatabaseManager _dbManager = DatabaseManager();
    String itemID = item['id'];
    print("构建文字区域显示组件 模板区域id: ${itemID}");
    try {
      // 根据programID和模板区域id查询节目中这个模板区域的配置
      ProgramItem? programItemData = await _dbManager
          .getProgramItemByProgramIdAndItemId(programId, itemID);
      print("查询到的节目中这个模板区域的配置:${programItemData?.toJson()}");
      String configData = programItemData?.url ?? "";
      TextItemData? textItemData;
      try {
        if (configData.isNotEmpty) {
          Map<String, dynamic> jsonData = json.decode(configData);
          textItemData = TextItemData.fromJson(jsonData);
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
      // final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      // final double flutterFontSize = webFontSize / devicePixelRatio;
      print("文字大小:${textItemData.textFontSize} 动画效果:${textItemData.textAnimalType} 字体:${textItemData.textFontFamily}");


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

      // 居中设置
      // Function to parse text alignment
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

      final textStyle = TextStyle(
        color: parseColor(textItemData.textColor),
        fontSize: double.tryParse((textItemData.textFontSize).toString()) ?? 20,
        fontFamily: textItemData.textFontFamily,
        fontWeight: parseFontWeight(textItemData.textWeight),
        fontStyle: parseFontStyle(textItemData.textStyle),
        decoration: parseUnderline(textItemData.textUnderline),
      );

      List<AnimatedText> getAnimatedTexts(String animalType,String textContent,String textAlign) {
        switch (animalType) {
          case 'none':
            print("无动画效果");
            return [
              // 无动画效果，直接使用普通 Text
              TyperAnimatedText(
                textContent,
                speed: const Duration(milliseconds: 0),
                textAlign: parseTextAlign(textAlign),
              ),
            ];
          case 'Fade':
            print("淡入淡出效果");
            return [
              FadeAnimatedText(
                textContent,
                duration: const Duration(seconds: 2),
                textAlign: parseTextAlign(textAlign),
              ),
            ];
          case 'Typer':
            print("打字效果");
            return [
              TyperAnimatedText(
                textContent,
                speed: const Duration(milliseconds: 100),
                textAlign: parseTextAlign(textAlign),
              ),
            ];
          case 'Scale':
            print("缩放效果");
            return [
              ScaleAnimatedText(
                textContent,
                textAlign: parseTextAlign(textAlign),
                duration: const Duration(milliseconds: 2000),
                scalingFactor: 0.5,
              ),
            ];
          case 'Flick':
            print("闪烁效果");
            return [
              FlickerAnimatedText(
                textContent,
                textStyle: textStyle,
                textAlign: parseTextAlign(textAlign),
              ),
            ];
          case 'Colorize':
            print("颜色变化效果");
            return [
              ColorizeAnimatedText(
                textContent,
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.yellow,
                  Colors.red,
                ],
                textStyle: textStyle,
                textAlign: parseTextAlign(textAlign),
              ),
            ];
          default:
            return [
              // 无动画效果，直接使用普通 Text
              TyperAnimatedText(
                textContent,
                speed: const Duration(milliseconds: 0),
                textAlign: parseTextAlign(textAlign),
              ),
            ];
        }
      }

      return Container(
        color: parseColor(textItemData.textBGColor),
        child: Align(
          child: SizedBox(
            width: double.infinity,
            child: DefaultTextStyle(
              style: textStyle,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: getAnimatedTexts(textItemData.textAnimalType,textItemData.textContent,textItemData.align),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print("Error in buildWidget: $e");
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
  @override
  void dispose() {
    print("Text Area Release");
  }
}