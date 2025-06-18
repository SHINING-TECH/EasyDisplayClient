class ClockItemData {
  final String timeArea;

  ClockItemData({
    required this.timeArea,
  });

  // 从 JSON 数据创建 ImageItem 实例
  factory ClockItemData.fromJson(Map<String, dynamic> json) {
    return ClockItemData(
      timeArea: json['timeArea']?? '',
    );
  }
}