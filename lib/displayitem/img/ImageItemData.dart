class ImageItemData {
  final String url;
  final String resourceId;//资源ID
  final String playId;//播放ID
  final int translateTime;

  ImageItemData({
    required this.url,
    required this.playId,
    required this.resourceId,
    required this.translateTime,
  });

  // 从 JSON 数据创建 ImageItem 实例
  factory ImageItemData.fromJson(Map<String, dynamic> json) {
    return ImageItemData(
      url: json['url']?? '',
      resourceId: json['resourceId']?? '',
      playId: json['playId']?? '',
      translateTime: json['translateTime']?? 0,
    );
  }
}