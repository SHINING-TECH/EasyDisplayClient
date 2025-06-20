import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:r_get_ip/r_get_ip.dart';
import '../l10n/localization.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../util/SharedPreferencesUtils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'en'; // 默认英文
  int _heartbeatInterval = 5; // 默认5秒
  String _appVersion = '未知版本'; // 初始化版本信息
  // 为不同组件创建 FocusNode
  final FocusNode _backButtonFocusNode = FocusNode();
  final FocusNode _exitButtonFocusNode = FocusNode();
  // 为每个 ListTile 创建 FocusNode 列表
  final List<FocusNode> _listTileFocusNodes = [];
  final List<bool> _listTileFocusedStates = [];

  bool _isBackButtonFocused = false;
  bool _isExitButtonFocused = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getAppVersion();
    // 初始化 FocusNode 和焦点状态列表，根据设置项数量调整
    final itemCount = 4; // 假设共有 4 个设置项
    for (int i = 0; i < itemCount; i++) {
      _listTileFocusNodes.add(FocusNode());
      _listTileFocusedStates.add(false);
    }
  }

  @override
  void dispose() {
    // 释放所有 FocusNode
    _backButtonFocusNode.dispose();
    _exitButtonFocusNode.dispose();
    for (var focusNode in _listTileFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    setState(() {
      _selectedLanguage = provider.locale.languageCode;
      _heartbeatInterval = provider.heartbeatInterval; // 直接从 LocaleProvider 获取
      print("当前配置 LangL:${_selectedLanguage} heartbeatInterval:${_heartbeatInterval}");
    });
  }

  Future<void> _getAppVersion() async {
    print("获取应用版本信息");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version}(${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FocusableActionDetector(
          focusNode: _backButtonFocusNode,
          onShowFocusHighlight: (isFocused) {
            setState(() {
              _isBackButtonFocused = isFocused;
            });
          },
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (RawKeyEvent event) {
              print("onKeyEvent");
              if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.select) {
                // 当遥控器按下确定键时执行回调
                print("back to home page");
                Navigator.of(context).pop();
              }
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                side: _isBackButtonFocused
                    ? BorderSide(color: Colors.lightBlue, width: 2)
                    : BorderSide.none,
              ),
              onPressed: () {
                print("back to home page");
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: Text(L10n.getString(context, 'settings')),
        elevation: 0, // 移除阴影
        actions: [
          FocusableActionDetector(
            focusNode: _exitButtonFocusNode,
            onShowFocusHighlight: (isFocused) {
              setState(() {
                _isExitButtonFocused = isFocused;
              });
            },
            child: IconButton(
              icon: const Icon(Icons.exit_to_app), // 退出图标
              style: IconButton.styleFrom(
                side: _isExitButtonFocused
                    ? BorderSide(color: Colors.lightBlue, width: 2)
                    : BorderSide.none,
              ),
              onPressed: () {
                // 处理退出逻辑，例如清除用户会话或返回登录页面
                _logout();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 16), // 顶部间距
              _buildSettingGroup(
                title: L10n.getString(context, 'general_settings'),
                children: [
                  //语言配置
                  _buildLanguageSelector(0),
                ],
              ),
              const SizedBox(height: 16), // 底部间距
              _buildSettingGroup(
                title: L10n.getString(context, 'service_settings'), // 新的配置类别
                children: [
                  // 新增平台地址配置
                  _buildPlatformAddressSelector(1),
                  const Divider(height: 1),
                  //当前终端是服务还是客户端
                  _buildServiceTypeSelector(2), // 新的服务类型选择器
                  const Divider(height: 1),
                  _buildHeartbeatSelector(3),
                ],
              ),
              const SizedBox(height: 16), // 底部间距
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '${L10n.getString(context, 'version')} $_appVersion',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FutureBuilder<String?>(
              future: SharedPreferencesUtils().getTerminalCode(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Text(
                      'Code: ${snapshot.data}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    );
                  } else {
                    return Text(
                      'Code: NA',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    );
                  }
                } else {
                  return Text(
                    'Code: Loading...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // 退出当前进程
    print("退出软件");
    exit(0); // 关闭应用程序
    SystemNavigator.pop(); // 关闭应用程序
  }

  Widget _buildSettingGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(int index) {
    return FocusableActionDetector(
      focusNode: _listTileFocusNodes[index],
      onShowFocusHighlight: (isFocused) {
        setState(() {
          _listTileFocusedStates[index] = isFocused;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: _listTileFocusedStates[index]
              ? Border.all(color: Colors.lightBlue, width: 2)
              : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            L10n.getString(context, 'language'),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            underline: const SizedBox(), // 移除下划线
            items: [
              DropdownMenuItem(
                value: 'zh',
                child: Text(L10n.getString(context, 'chinese')),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Text(L10n.getString(context, 'english')),
              ),
              DropdownMenuItem(
                value: 'ja',
                child: Text(L10n.getString(context, 'ja')),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                });
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(newValue);
              }
            },
          ),
        ),
      ),
    );
  }

  //服务平台地址
  Widget _buildPlatformAddressSelector(int index) {
    String _platformAddress = ''; // 假设初始值为空
    final provider = Provider.of<LocaleProvider>(context);
    return FocusableActionDetector(
      focusNode: _listTileFocusNodes[index],
      onShowFocusHighlight: (isFocused) {
        setState(() {
          _listTileFocusedStates[index] = isFocused;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: _listTileFocusedStates[index]
              ? Border.all(color: Colors.lightBlue, width: 2)
              : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.web,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            L10n.getString(context, 'platform_address'),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: FutureBuilder(
                  builder: _buildServerAddressWidget,
                  future: RGetIp.internalIP,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServerAddressWidget(BuildContext context, AsyncSnapshot<String?> snapshot) {
    return Text(
      'http://${snapshot.data ?? "0.0.0.0"}:8080',
      style: TextStyle(
        color: Colors.black, // 文字颜色
        fontSize: 14, // 文字大小
      ),
    );
  }

  //设备类型配置
  Widget _buildServiceTypeSelector(int index) {
    final provider = Provider.of<LocaleProvider>(context);
    return FocusableActionDetector(
      focusNode: _listTileFocusNodes[index],
      onShowFocusHighlight: (isFocused) {
        setState(() {
          _listTileFocusedStates[index] = isFocused;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: _listTileFocusedStates[index]
              ? Border.all(color: Colors.lightBlue, width: 2)
              : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.device_hub,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            L10n.getString(context, 'service_type'),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: DropdownButton<String>(
            underline: const SizedBox(), // 移除下划线
            value: provider.serviceType,
            items: [
              DropdownMenuItem(
                value: 'Client&Server',
                child: Text(L10n.getString(context, 'host')),
              ),
              DropdownMenuItem(
                value: 'Client',
                child: Text(L10n.getString(context, 'slave')),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                provider.setServiceType(newValue); // 保存服务类型
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeartbeatSelector(int index) {
    return FocusableActionDetector(
      focusNode: _listTileFocusNodes[index],
      onShowFocusHighlight: (isFocused) {
        setState(() {
          _listTileFocusedStates[index] = isFocused;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: _listTileFocusedStates[index]
              ? Border.all(color: Colors.lightBlue, width: 2)
              : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.timer,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            L10n.getString(context, 'heartbeat_interval'),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: DropdownButton<int>(
            value: _heartbeatInterval,
            underline: const SizedBox(), // 移除下划线
            items: [5, 10, 15, 30, 60].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value ${L10n.getString(context, 'seconds')}'),
              );
            }).toList(),
            onChanged: (int? newValue) async {
              if (newValue != null) {
                setState(() {
                  _heartbeatInterval = newValue;
                });
                // 更新心跳间隔
                Provider.of<LocaleProvider>(context, listen: false)
                    .setHeartBeatInterval(newValue);
              }
            },
          ),
        ),
      ),
    );
  }
}