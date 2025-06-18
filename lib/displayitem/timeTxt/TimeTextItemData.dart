/**
 * {"type":"timeTxt","textContent":"啦222啦啦啦","textColor":"rgba(206, 237, 9, 0.99)",
    "textFontSize":54,"textFontFamily":"Arial"
    ,"textBGColor":"#ffffff00","align":"center","textWeight":"normal","textStyle":"normal","textUnderline":"none"}
 */
class TimeTextItemData {
  // 添加注释中的字段
  final String type;
  final String timeArea;
  final String textColor;
  final int textFontSize;
  final String textBGColor;
  final String align;
  final String textWeight;
  final String textStyle;
  final String textUnderline;

  TimeTextItemData({
    // 初始化注释中的字段
    required this.type,
    required this.timeArea,
    required this.textColor,
    required this.textFontSize,
    required this.textBGColor,
    required this.align,
    required this.textWeight,
    required this.textStyle,
    required this.textUnderline,
  });

  // 从 JSON 数据创建 TextItemData 实例
  factory TimeTextItemData.fromJson(Map<String, dynamic> json) {
    return TimeTextItemData(
      // 从 JSON 中解析注释中的字段
      type: json['type']?? '',
      timeArea: json['timeArea']?? '',
      textColor: json['textColor']?? '',
      textFontSize: json['textFontSize']?? 0,
      textBGColor: json['textBGColor']?? '',
      align: json['align']?? '',
      textWeight: json['textWeight']?? '',
      textStyle: json['textStyle']?? '',
      textUnderline: json['textUnderline']?? '',
    );
  }
}