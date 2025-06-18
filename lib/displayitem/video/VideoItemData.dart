class VideoItemData {
  final String url;
  final String resourceId;//资源ID
  final String playId;
  final String thumbile;

  VideoItemData({
    required this.url,
    required this.resourceId,
    required this.playId,
    required this.thumbile,
  });

  // 从 JSON 数据创建 ImageItem 实例
  factory VideoItemData.fromJson(Map<String, dynamic> json) {
    return VideoItemData(
      url: json['url']?? '',
      resourceId: json['resourceId']?? '',
      playId: json['playId']?? '',
      thumbile: json['thumbile']?? '',
    );
  }
}