import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static const String _languageKey = 'language_code';
  static const String _heartbeatKey = 'heartbeat_interval';
  static const String _serviceTypeKey = 'service_type';
  static const String _deviceIdKey = 'device_id';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<String?> getSavedLanguage() async {
    final prefs = await _getPrefs();
    return prefs.getString(_languageKey);
  }

  Future<String?> getSavedServiceType() async {
    final prefs = await _getPrefs();
    return prefs.getString(_serviceTypeKey);
  }

  Future<int> getHeartBeatInterval() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_heartbeatKey) ?? 5;
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<void> setServiceType(String serviceType) async {
    final prefs = await _getPrefs();
    await prefs.setString(_serviceTypeKey, serviceType);
  }

  Future<void> setHeartBeatInterval(int interval) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_heartbeatKey, interval);
  }

  Future<void> setTerminalCode(String interval) async {
    final prefs = await _getPrefs();
    await prefs.setString(_deviceIdKey, interval);
  }

  Future<String?> getTerminalCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(_deviceIdKey);
  }
}
