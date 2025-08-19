import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:snap_vison_client/util/DeviceInfoUtil.dart';

class MixpanelService {
  static Mixpanel? _instance;

  static Future<void> init(String token) async {
    print("初始化 Mixpanel");
    _instance = await Mixpanel.init(token, trackAutomaticEvents: false);
    if (_instance != null) {
      _instance?.identify(DeviceInfo.getHardWareDeviceId());
      print("初始化 Mixpanel identify :${DeviceInfo.getHardWareDeviceId()}");
    }
  }

  static Mixpanel get instance {
    if (_instance == null) {
      throw Exception('Mixpanel not initialized. Call init() first.');
    }
    return _instance!;
  }

  static Future<void> track(String event, [Map<String, dynamic>? properties]) async {
    instance.track(event, properties: properties);
    instance.flush();
  }
}
