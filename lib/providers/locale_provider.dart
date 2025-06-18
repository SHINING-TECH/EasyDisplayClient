import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snap_vison_client/util/SharedPreferencesUtils.dart';

class LocaleProvider extends ChangeNotifier {
  late SharedPreferencesUtils _sharedPreferencesUtils;
  Locale _locale;
  String _serviceType;
  int _heartbeatInterval;

  LocaleProvider(this._sharedPreferencesUtils)
      : _locale = _getDefaultLocale(),
        _serviceType = 'Client&Server',
        _heartbeatInterval = 5{
    _loadSavedLanguage();
    _loadSavedServiceType();
    _loadHeartBeatInterval();
  }

  // 新增方法，用于获取默认语言
  static  Locale _getDefaultLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    final validLocales = ['en', 'zh', 'ja'];
    final systemLocaleString = '${systemLocale.languageCode}';

    if (validLocales.contains(systemLocaleString)) {
      return Locale(systemLocaleString);
    } else {
      return const Locale('en');
    }
  }

  Locale get locale => _locale;
  String get serviceType => _serviceType;
  int get heartbeatInterval => _heartbeatInterval;

  //设置本地语言
  Future<void> _loadSavedLanguage() async {
    final String? savedLanguage = await _sharedPreferencesUtils.getSavedLanguage();
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  //设置本地语言
  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await _sharedPreferencesUtils.setLocale(languageCode);
    notifyListeners();
  }

  //设置服务类型
  Future<void> setServiceType(String serviceType) async {
    _serviceType = serviceType;
    await _sharedPreferencesUtils.setServiceType(serviceType);
    notifyListeners();
  }

  //获取服务类型
  Future<void> _loadSavedServiceType() async {
    final String? savedServiceType = await _sharedPreferencesUtils.getSavedServiceType();
    if (savedServiceType != null) {
      _serviceType = savedServiceType;
      notifyListeners();
    }
  }

  //设置心跳间隔
  Future<void> setHeartBeatInterval(int interval) async {
    print("设置心跳间隔:${interval}");
    _heartbeatInterval = interval;
    await _sharedPreferencesUtils.setHeartBeatInterval(interval);
    notifyListeners();
  }


  // 获取心跳间隔，默认5秒
  Future<void> _loadHeartBeatInterval() async {
    _heartbeatInterval = await _sharedPreferencesUtils.getHeartBeatInterval();
     notifyListeners();
  }

}
