import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static var deviceData = <String, dynamic>{};

  // 获取设备信息
  static Future<void> getDeviceInto() async {
    try {
      deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.android =>
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.iOS =>
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
        TargetPlatform.linux =>
          _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
        TargetPlatform.windows =>
          _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
        TargetPlatform.macOS =>
          _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
        TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported'
          },
      };

      // 打印出系统信息
      print("Device Info: $deviceData");
      //打印出系统信息
      print("deviceId:${deviceData["device id"]}");
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  // 获取系统用户名
  static String getUserName() {
    if(defaultTargetPlatform == TargetPlatform.android){
      return Platform.environment['USER'] ?? 'Unknown';
    }
    return deviceData["userName"];
  }

  // 获取硬件ID
  static String getDeviceId() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    String deviceId = '';
    for (int i = 0; i < 6; i++) {
      deviceId += chars[random.nextInt(chars.length)];
    }
    return deviceId;
  }

  // 获取系统类型
  static String getOperatingSystem() {
    return Platform
        .operatingSystem; // 返回操作系统类型，例如 "android", "ios", "linux", "macos", "windows"
  }

  // 获取硬件屏幕分辨率
  static String getScreenResolution() {
    return '1920 x 1080'; // 默认分辨率
  }


  static Future<String> getCurrentSoftwareVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  // 获取系统版本
  static String getSystemVersion() {
    if(defaultTargetPlatform == TargetPlatform.android){
      return deviceData["version.sdkInt"]?.toString() ?? 'Unknown';  // 添加to
    }
    return deviceData["userName"];
    return deviceData["productName"]; // 返回系统版本信息
  }

  // 获取 MAC 地址
  static Future<String> getMacAddress() async {
    // 在 Dart 中获取 MAC 地址通常需要使用第三方库
    // 这里假设您使用了 `network_info_plus` 库
    // final NetworkInfo networkInfo = NetworkInfo();
    // return await networkInfo.getWifiBSSID();

    // String _macAddress = 'Unknown';
    // try {
    //   final _getMacAddressPlugin = GetMacAddress();
    //   _macAddress = await _getMacAddressPlugin.getMacAddress() ?? 'Unknown mac address';
    // } on PlatformException {
    //   _macAddress = 'Failed to get mac address.';
    // }
    return "0A:0A:0A:0A"; // 作为占位符
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'device id': build.id,
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build,
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  static Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  static Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  static Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }
}
