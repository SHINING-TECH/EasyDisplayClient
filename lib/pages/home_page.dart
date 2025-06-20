import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snap_vison_client/config/app_config.dart';
import 'package:snap_vison_client/server/ServerManage.dart';
import 'package:r_get_ip/r_get_ip.dart';
import 'package:snap_vison_client/util/FileUtil.dart';
import 'package:snap_vison_client/pages/settings_page.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../database/database.dart';
import '../database/database_manager.dart';
import '../event/event_bus.dart';
import '../event/program_event.dart';
import '../event/refresh_display_event.dart';
import '../l10n/localization.dart';
import '../util/SharedPreferencesUtils.dart';
import '../util/StateHelper.dart';
import 'display_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseManager _dbManager = DatabaseManager();
  final ServerManage _serverManage = ServerManage();
  String? ipv4Address;
  //TV焦点
  final FocusNode _settingsButtonFocusNode = FocusNode();
  bool _isButtonFocused = false;

  @override
  void dispose() {
    // 释放焦点节点
    _settingsButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _getExternalIp();
    //获取当前设备的发布事件ID
    checkNowPlayProgram();
    //监听节目发布事件
    eventBus.on<ProgramIdEvent>().listen((event) {
      // 处理接收到的 programId
      print('Received publish event type: ${event.type}');
      switch (event.type) {
        case AppConfig.publishProgram:
        // 可以在这里更新 UI 或执行其他操作
          print('Received publish: ${event.publishId}');
          AppConfig().nowPlayingPublishId = event.publishId;
          getProgramData(event.publishId);
          break;
        case AppConfig.deleteProgram:
          print('Received delete: ${event.publishId} nowPlayID:${AppConfig().nowPlayingPublishId}');
          if(event.publishId == AppConfig().nowPlayingPublishId){
            print('停止播放');
            Navigator.popUntil(context, (route) {
              return route.settings.name != '/display';
            });
          }
          break;
        default:
        // 处理其他情况
          break;
      }
    });
  }

  Future<void> _getExternalIp() async {
    ipv4Address = await RGetIp.internalIP;
    print("获取IP完成 $ipv4Address");
    _serverManage.startServer(ipv4Address ?? "0.0.0.0", 8080);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  builder: _buildServerAddressWidget,
                  future: RGetIp.internalIP,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: FocusableActionDetector(
              focusNode: _settingsButtonFocusNode,
              onShowFocusHighlight: (isFocused) {
                setState(() {
                  // 可根据 isFocused 状态更新 UI，如改变按钮颜色
                  _isButtonFocused = isFocused;
                });
              },
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // 根据焦点状态添加外边框
                  side: _isButtonFocused
                      ? BorderSide(color: Colors.lightBlue, width: 2)
                      : BorderSide.none,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
                icon: const Icon(Icons.settings),
                label: Text(L10n.getString(context, 'settings')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIpWidget(BuildContext context, AsyncSnapshot<String?> snapshot) {
    return Text('Net Type: ${snapshot.data ?? "Unknown"}');
  }

  Widget _buildServerAddressWidget(BuildContext context, AsyncSnapshot<String?> snapshot) {
    return Align(
      alignment: Alignment.topCenter, // 横向居中，纵向顶部对齐
      child: SingleChildScrollView( // 避免小屏设备内容超出
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 让内容高度自适应
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${L10n.getString(context, 'serverPath')} http://${snapshot.data ?? "0.0.0.0"}:8080',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                // 使用说明块
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blueGrey),
                          SizedBox(width: 6),
                          // 使用 Flexible 包裹 Text 组件，让文字在空间不足时换行
                          Flexible(
                            child: Text(
                              L10n.getString(context, 'serverUseTips'),
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        L10n.getString(context, 'serverUseTips1'),
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: L10n.getString(context, 'serverUseTips2') + ' ',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                          children: const [
                            TextSpan(
                              text: 'admin / admin123',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void getProgramData(int publishId) async{
    //根据publishId查询出programId
    ServerPublishData? serverPublishData = await _dbManager.getServerPublishById(publishId);
    int programId = int.tryParse(serverPublishData?.proId?? "0")?? 0;
    ProgramData? programData =await _dbManager.getProgramByProgramId(programId);
    if(programData != null){
      print("节目数据:${programData.toJson()}");
      int programID = programData.id;
      print("节目ID:${programID}");
      //获取模板Id
      int templateID = programData.modelId;
      print("模板ID:${templateID}");
      //查询模板数据
      Template? templateData = await _dbManager.getTemplateById(templateID);
      if(templateData != null){
        print("节目分辨率:${templateData.resolution}");
        List<TemplateItem> templateItemsData = await _dbManager.getTemplateItemsByTemplateId(templateData.id);
        // 将 templateItemsData 转换为可序列化的列表
        List<Map<String, dynamic>> serializedList = templateItemsData.map((item) => item.toJson()).toList();
        // 将可序列化的列表转换为 JSON 字符串
        String jsonString = json.encode(serializedList);
        print("模板配置:$jsonString");
        navigateToDisplayPage(context,programID,templateData.resolution, jsonString);
      }
    }
  }

  void navigateToDisplayPage(BuildContext context, int programId,String resolution, String jsonString) {
    final isExist = StateHelper.has<DisplayPage>();
    print("DisplayPage页面是否存在:${isExist}");

    if (isExist) {
      // 已经在 DisplayPage，直接更新数据（通过Eventbus进行数据更新）
      print("更新绘制数据");
      // 发送事件通知
      eventBus.fire(RefreshDisplayEvent(programId,jsonString));
      //延迟2s后重新创建绘制页面
      Future.delayed(Duration(milliseconds: 60), () {
        // 重新创建绘制页面
        print("重新创建绘制页面");
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: "/display"),
            builder: (context) => DisplayPage(programID: programId,temResolution: resolution,jsonString: jsonString),
          ),
        );
      });
    } else {
      // 进入 DisplayPage
      print("创建绘制页面");
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: RouteSettings(name: "/display"),
          builder: (context) => DisplayPage(programID: programId,temResolution: resolution,jsonString: jsonString),
        ),
      );
    }
  }

  Future<void> checkNowPlayProgram() async {
    String? terminalCode = await SharedPreferencesUtils().getTerminalCode();
    print("设备ID:$terminalCode");
    if(terminalCode != null){
      List<ServerPublishData> allServerPublish = await _dbManager.getAllServerPublishes();
      print("当前本地发布列表size:${allServerPublish.length}");
      ServerPublishData? serverPublishData = await _dbManager.getLatestServerPublishByTerminalId(terminalCode);
      if(serverPublishData!= null){
         AppConfig().nowPlayingPublishId = serverPublishData.id;
         print("当前播放 发布ID:${serverPublishData.id}  updateTime:${serverPublishData.updatedAt}");
         getProgramData(AppConfig().nowPlayingPublishId);
      } else {
         print("没有找到当前播放节目");
      }
    }
  }
}
