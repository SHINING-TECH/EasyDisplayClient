import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snap_vison_client/database/database.dart';
import 'package:snap_vison_client/displayitem/video/VideoWidgetBuilder.dart';
import 'package:snap_vison_client/pages/settings_page.dart';

import '../database/database_manager.dart';
import '../displayitem/BaseDisplayWidget.dart';
import '../displayitem/clock/ClockWidgetBuilder.dart';
import '../displayitem/img/ImageWidgetBuilder.dart';
import '../displayitem/scrolltext/display_item_scroll_text.dart';
import '../displayitem/text/TextWidgetBuilder.dart';
import '../displayitem/timeTxt/TimeTextWidgetBuilder.dart';
import '../event/event_bus.dart';
import '../event/refresh_display_event.dart';
import '../util/SharedPreferencesUtils.dart';
import '../util/StateHelper.dart';
import '../widget/PasswordDialog.dart';

/**
 * 核心功能类，负责整体页面绘制
 */
class DisplayPage extends StatefulWidget {
  final int programID;
  final String jsonString; // 新增：接收 jsonString 参数
  final String temResolution;//模板分辨率

  const DisplayPage({Key? key,required this.programID, required this.temResolution, required this.jsonString}) : super(key: key);

  @override
  StateEx<DisplayPage> createState() => DisplayPageState();
}

class DisplayPageState extends StateEx<DisplayPage> {
  late int programID;
  late String jsonString;
  late String temResolution;//模板分辨率
  List<BaseDisplayWidget> displayWidgets = []; // 维护组件实例列表

  // 定义触发密码对话框的方法
  Future<void> _triggerPasswordDialog() async {
    final DatabaseManager _dbManager = DatabaseManager();
    String? terminalCode = await SharedPreferencesUtils().getTerminalCode();
    String psw = await _dbManager.getTerminalsPsw(terminalCode?? "");
    if(psw.isNotEmpty){
      PasswordDialog.show(context, psw,() {
        // 密码正确，跳转到系统设置页面
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
      });
    } else {
      // 密码为空，跳转到系统设置页面
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }
  }

  @override
  void dispose() {
    // 在这里添加销毁监听的逻辑
    print('销毁播放页,displayWidgets size:${displayWidgets.length}');
    for (var widget in displayWidgets) {
      print('销毁播放页,调用 dispose');
      widget.dispose();
    }
    print('DisplayPageState 已销毁');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //监听节目发布事件
    eventBus.on<RefreshDisplayEvent>().listen((event) {
      // 处理接收到的 programId
      var newProgramId = event.programId;
      var newJsonString = event.jsonData;
      print('Received RefreshDisplay Event  newProgramId: ${newProgramId} newJsonString:${newJsonString}');
      // 退出当前页面
      if (Navigator.canPop(context)) {
        print("退出页面");
        Navigator.pop(context);
      } else {
        print("退出页面失败");
      }
    });
    // programID = widget.programID;
    // jsonString = widget.jsonString;
  }

  // 新增：更新 jsonString 并重绘
  void updateJsonString(int newProgramId,String newJsonString) {
    setState(() {
      print('DisplayPage 更新页面');
      programID = newProgramId;
      jsonString = newJsonString;
    });
  }

  // 新增：释放资源的方法
  void release() {
    // 在这里实现视频、图片等资源的释放逻辑
    print('DisplayPage 资源已释放');
  }

  Future<Widget> _buildWidgetByType(int programId,Map<String, dynamic> item) async {
    String type = item['type'];
    switch (type) {
      case "BG":
        String backgroundUrl = item['backGround'];
        String resourceIdStr = item['resourceId'];
        print("backgroundUrl:$backgroundUrl resourceId:$resourceIdStr");
        //根据resourceId查询资源实体类，找到本路路径，播放本地路径资源
        String localPath = '';
        if (resourceIdStr.isNotEmpty) {
          try {
            int resourceId = int.parse(resourceIdStr); // 将字符串转换为 int 类型
            DatabaseManager _dbManager = DatabaseManager();
            // 根据资源ID查询资源实体类
            ResourceData? resource = await _dbManager.getResourceById(resourceId);
            if (resource != null && resource.localFilePath.isNotEmpty) {
              localPath = resource.localFilePath;
            }
          } catch (e) {
            print("解析 resourceId 失败: $e");
          }
        }
        print("BG-本地资源路径: $localPath");
        if (localPath.isNotEmpty) {
          // 播放本地资源
          print("BG-播放本地资源");
          return Image.file(
            File(localPath),
            fit: BoxFit.fill,
          );
        } else if (backgroundUrl.isNotEmpty) {
          print("BG-播放网络资源:$backgroundUrl");
          return Image.network(
            backgroundUrl,
            fit: BoxFit.fill,
          );
        } else {
          print("BG-未设置资源");
          return Container(
            color: Colors.black,
          );
        }
      case "image":
        final imageBuilder = ImageWidgetBuilder();
        displayWidgets.add(imageBuilder); // 添加到列表
        final imageWidget = await imageBuilder.buildWidget(programId,item);
        return imageWidget;
      case "video":
        final videoBuilder = VideoWidgetBuilder();
        displayWidgets.add(videoBuilder); // 添加到列表
        final videoWidget = await videoBuilder.buildWidget(programId,item);
        return videoWidget;
      case "txt":
        final textBuilder = TextWidgetBuilder();
        displayWidgets.add(textBuilder); // 添加到列表
        final textWidget = await textBuilder.buildWidget(programId,item);
        return textWidget;
      case "scroll":
        return await ScrollTextWidgetBuilder.buildScrollTextWidget(programId,item);
      case "clock":
        final clockBuilder = ClockWidgetBuilder();
        displayWidgets.add(clockBuilder); // 添加到列表
        final clockWidget = await clockBuilder.buildWidget(programId,item);
        return clockWidget;
      case "timeTxt":
        final timeTxtBuilder = TimeTextWidgetBuilder();
        displayWidgets.add(timeTxtBuilder); // 添加到列表
        final timeTxtWidget = await timeTxtBuilder.buildWidget(programId,item);
        return timeTxtWidget;
      default:
        return Container(
          color: Colors.grey,
          child: Center(child: Text("UnKnow Area")),
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTapDown: (TapDownDetails details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          // 获取用户点击的全局坐标并转换为局部坐标
          final Offset tapPosition = renderBox.globalToLocal(details.globalPosition);
          print("点击屏幕 x:${tapPosition.dx} y:${tapPosition.dy}");
          // 判断是否点击左上角
          if (tapPosition.dx < 50 && tapPosition.dy < 50) {

            _triggerPasswordDialog();
          }
        },
        child: TemplateScreen(
          programId: widget.programID,
          temResolution: widget.temResolution,
          jsonData: widget.jsonString,
          buildWidgetByType: _buildWidgetByType,
        ),
      ),
    );
  }
}

class TemplateScreen extends StatelessWidget {
  final int programId;
  final String temResolution;//模板分辨率
  final String jsonData; // 新增：接收 jsonData 参数
  final Future<Widget> Function(int programId, Map<String, dynamic> item) buildWidgetByType;

  const TemplateScreen({
    Key? key,
    required this.programId,
    required this.temResolution,
    required this.jsonData,
    required this.buildWidgetByType,
  }) : super(key: key);

  final String jsonDataTest = '''
  [
    {
      "id": "1740989318696",
      "templateId": 2,
      "backGround": "",
      "height": 555.0,
      "name": "image1",
      "type": "image",
      "width": 840.0,
      "x": 60,
      "y": 482,
      "zIndex": 10,
      "backGround": "http://192.168.20.224:8080/infinity_2522099.jpg"
    },
    {
      "id": "1740989343922",
      "templateId": 2,
      "backGround": "",
      "height": 125.0,
      "name": "scroll",
      "type": "scroll",
      "width": 1920.0,
      "x": 0,
      "y": 0,
      "zIndex": 11
    },
    {
      "id": "1740989341136",
      "templateId": 2,
      "backGround": "http://192.168.20.224:8080/infinity_2522099.jpg",
      "height": 1080.0,
      "name": "BG",
      "type": "BG",
      "width": 1920.0,
      "x": 0,
      "y": 0,
      "zIndex": 1
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    final int nowProgramId  = programId;
    final List<dynamic> temItems = jsonDecode(jsonData);

    // 这里假设设计稿宽度和高度是固定的，可根据实际情况调整
    // temResolution 的值为 1920*1080  1280*720   1080*1740 720*1280 1920*200 1080*1920
    List<String> resolutionParts = temResolution.split('*');
    double designWidth = resolutionParts.length >= 2 ? double.tryParse(resolutionParts[0]) ?? 1920 : 1920;
    double designHeight = resolutionParts.length >= 2 ? double.tryParse(resolutionParts[1]) ?? 1080 : 1080;

    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    print("screenWidth: $screenWidth designWidth: $designWidth");
    print("screenHeight: $screenHeight designHeight: $designHeight");

    double scaleX = screenWidth / designWidth; // 宽度缩放比例
    double scaleY = screenHeight / designHeight; // 高度缩放比例
    print("scaleX: $scaleX scaleY: $scaleY");

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Stack(
            children: _buildWidgets(nowProgramId,temItems, scaleX, scaleY),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWidgets(int programId,List<dynamic> temItems, double scaleX,
      double scaleY) {
    temItems.sort((a, b) => (a['zIndex'] as int).compareTo(b['zIndex'] as int));

    return temItems.map((item) {
      double x = item['x'].toDouble() * scaleX;
      double y = item['y'].toDouble() * scaleY;
      double width = item['width'].toDouble() * scaleX;
      double height = item['height'].toDouble() * scaleY;

      return Positioned(
        left: x,
        top: y,
        width: width,
        height: height,
        child: FutureBuilder<Widget>(
          future: buildWidgetByType(programId, item),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return Container();
            }
          },
        ),
      );
    }).toList();
  }
}
