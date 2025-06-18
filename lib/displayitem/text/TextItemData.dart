/**
 * {"type":"txt","textContent":"啦222啦啦啦","textColor":"rgba(206, 237, 9, 0.99)",
    "textFontSize":54,"textFontFamily":"Arial"
    ,"textBGColor":"#ffffff00","align":"center","textWeight":"normal","textStyle":"normal","textUnderline":"none"}
 */
class TextItemData {
  // 添加注释中的字段
  final String type;
  final String textContent;
  final String textColor;
  final int textFontSize;
  final String textFontFamily;
  final String textBGColor;
  final String align;
  final String textWeight;
  final String textStyle;
  final String textUnderline;

  TextItemData({
    // 初始化注释中的字段
    required this.type,
    required this.textContent,
    required this.textColor,
    required this.textFontSize,
    required this.textFontFamily,
    required this.textBGColor,
    required this.align,
    required this.textWeight,
    required this.textStyle,
    required this.textUnderline,
  });

  // 从 JSON 数据创建 TextItemData 实例
  factory TextItemData.fromJson(Map<String, dynamic> json) {
    return TextItemData(
      // 从 JSON 中解析注释中的字段
      type: json['type']?? '',
      textContent: json['textContent']?? '',
      textColor: json['textColor']?? '',
      textFontSize: json['textFontSize']?? 0,
      textFontFamily: json['textFontFamily']?? '',
      textBGColor: json['textBGColor']?? '',
      align: json['align']?? '',
      textWeight: json['textWeight']?? '',
      textStyle: json['textStyle']?? '',
      textUnderline: json['textUnderline']?? '',
    );
  }
}