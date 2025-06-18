import 'package:flutter/cupertino.dart';

class AppConfig {
  // 单例实例
  static final AppConfig _instance = AppConfig._internal();

  // 获取单例实例
  factory AppConfig() => _instance;

  // 私有构造函数，防止外部创建实例
  AppConfig._internal();

  // 配置变量
  late String webVersion = "web20250605";

  //当前播放的播放计划id
  late int nowPlayingPublishId = 0;

  // cmdType
  //重启应用
  static const String  restartProcess = "restartProcess";
  //关闭应用
  static const String  closeProcess = "closeProcess";
  //发布节目
  static const String  publishProgram = "publishProgram";
  //删除节目
  static const String  deleteProgram = "deleteProgram";

  late BuildContext appContext;

}
