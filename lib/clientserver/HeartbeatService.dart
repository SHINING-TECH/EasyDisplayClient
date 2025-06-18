import 'dart:async';
import 'package:snap_vison_client/log/Logger.dart';

import '../config/app_config.dart';
import '../database/database.dart';
import '../database/database_manager.dart';
import '../providers/locale_provider.dart';
import '../util/SharedPreferencesUtils.dart';
import 'package:snap_vison_client/config/app_config.dart';

class HeartbeatService {
  Timer? _timer;
  Duration _interval = Duration(seconds: 10); // 默认间隔为 10 秒
  final DatabaseManager _dbManager = DatabaseManager();

  HeartbeatService(LocaleProvider localeProvider) {
    Logger().log('HeartbeatService 初始化');
    // 初始化时读取保存的心跳间隔
    _interval = Duration(seconds: localeProvider.heartbeatInterval);
    // 监听 heartBeatInterval 变化
    localeProvider.addListener(() => listenForHeartBeatInterval(localeProvider));
  }

  // 启动心跳服务
  void start() {
    Logger().log('心跳服务开启');
    _startTimer();

  }

  // 停止心跳服务
  void stop() {
    _timer?.cancel();
    Logger().log('停止心跳服务');
  }

  // 更新心跳间隔
  void updateInterval(int seconds) {
    Logger().log('更新心跳时间');
    _interval = Duration(seconds: seconds);
    _restartTimer();
  }

  // 启动定时器
  void _startTimer() {
    Logger().log('心跳定时器启动: ${_interval.inSeconds} seconds.');
    _timer = Timer.periodic(_interval, (timer) {
      _executeHeartbeatLogic();
    });
  }

  // 重新启动定时器
  void _restartTimer() {
    Logger().log('重启心跳定时器');
    stop(); // 停止当前定时器
    _startTimer(); // 启动新的定时器
  }

  // 执行心跳逻辑
  void _executeHeartbeatLogic() async{
    Logger().log('Heartbeat logic executed at ${DateTime.now()}');
    // 在这里添加您希望每次执行的逻辑
    if(true){
      //作为服务端+客户端模式-直接从本地数据库取，减少网络请求
      //更新本地设备的更新时间
      String? terminalCode = await SharedPreferencesUtils().getTerminalCode();
      if(terminalCode != null){
        int result = await  _dbManager.updateTerminalTimeByTerminalCode(terminalCode);
        Logger().log('更新最后一次通讯时间 ${DateTime.now()}');
      }
    } else {
      //作为纯客户端模式-通过网络接口获取
      //读取最新的推送指令
      CmdInfoData? cmdInfoData = await _dbManager.getLatestCmdInfo();
      if(cmdInfoData != null){
        if(cmdInfoData.flag == 0){
          switch(cmdInfoData.flag){

          }
        }
      }
    }
  }


  // 监听心跳间隔的变化
  void listenForHeartBeatInterval(LocaleProvider localeProvider) {
    Logger().log("listenForHeartBeatInterval 触发");
    // 只在心跳间隔变化时才重新启动定时器
    if (_interval.inSeconds != localeProvider.heartbeatInterval) {
      Logger().log("心跳配置发生改变");
      _interval = Duration(seconds: localeProvider.heartbeatInterval);
      _restartTimer(); // 更新间隔后重新启动定时器
    }
  }
}