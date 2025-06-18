import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:snap_vison_client/config/app_config.dart';
import 'package:snap_vison_client/util/FileUtil.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'package:snap_vison_client/util/DeviceInfoUtil.dart';
import 'package:snap_vison_client/util/SharedPreferencesUtils.dart';
import 'package:snap_vison_client/providers/locale_provider.dart';
import 'package:snap_vison_client/database/database_manager.dart';
import 'package:snap_vison_client/clientserver/HeartbeatService.dart';
import 'package:snap_vison_client/main_app.dart';

import 'l10n/localization.dart'; // 引入 MyApp

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // 全屏 & 手势唤出
    print("初始化开始...");

    // 获取设备信息
    await DeviceInfo.getDeviceInto();
    int deviceInfoTime = DateTime.now().millisecondsSinceEpoch;
    print("初始化 Step1 - >获取设备信息耗时: ${deviceInfoTime - startTime} ms");

    // 获取当前设备语言
    final systemLocale = PlatformDispatcher.instance.locale;
    //当前设备语言  英文美国: en-US   中文简体: zh-CN  日本语: ja-JP
    final String? savedLanguage = await SharedPreferencesUtils().getSavedLanguage();
    print("当前设备语言: ${systemLocale.languageCode}-${systemLocale.countryCode} 软件设定语言: ${savedLanguage}");
    if (savedLanguage != null) {
      L10n.setLocale(savedLanguage);
    } else {
      SharedPreferencesUtils().setLocale(systemLocale.languageCode);
      L10n.setLocale(systemLocale.languageCode);
    }

    // 初始化数据库
    final dbManager = DatabaseManager();
    int dbInitTime = DateTime.now().millisecondsSinceEpoch;
    print("初始化 Step2 - >数据库初始化耗时: ${dbInitTime - deviceInfoTime} ms");

    // 创建 LocaleProvider 并等待初始化
    final localeProvider = LocaleProvider(SharedPreferencesUtils());
    await Future.delayed(const Duration(milliseconds: 100));
    int localeProviderTime = DateTime.now().millisecondsSinceEpoch;
    print("初始化 Step3 - >语言环境初始化耗时: ${localeProviderTime - dbInitTime} ms");

    // 启动心跳服务
    final heartbeatService = HeartbeatService(localeProvider);
    heartbeatService.start();
    int heartbeatTime = DateTime.now().millisecondsSinceEpoch;
    print("初始化 Step4 - >心跳服务启动耗时: ${heartbeatTime - localeProviderTime} ms");

    // 复制 Web 资源
    int webCopyStartTime = DateTime.now().millisecondsSinceEpoch;
    await FileUtil.copyWebAssets(
      assetsWebFileZipName: "${AppConfig().webVersion}.zip",
      localWebFileFolder: "${AppConfig().webVersion}",
      onComplete: () {
        int webCopyEndTime = DateTime.now().millisecondsSinceEpoch;
        print("初始化 Step5 - >Web 资源复制完成，耗时: ${webCopyEndTime - webCopyStartTime} ms");
      },
      onError: (error) {
        print("初始化 Step5 - >Web 资源复制失败: $error");
      },
    );

    // 窗口管理（仅 Windows）
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = WindowOptions(
        //size: Size(1920, 1080),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
      );
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
        await windowManager.setFullScreen(true);
      });
      int windowTime = DateTime.now().millisecondsSinceEpoch;
      print("初始化 Step6 - >窗口管理初始化耗时: ${windowTime - heartbeatTime} ms");
    } else if (defaultTargetPlatform == TargetPlatform.android)  {

    }
    MediaKit.ensureInitialized();
    // 总耗时
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("初始化 总耗时: ${endTime - startTime} ms");

    // 进入主页面
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider.value(
        value: localeProvider,
        child: const MyApp(),
      ),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // 你可以换成自己的启动页 UI
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Loading...", style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
