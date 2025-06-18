import 'dart:io';
import 'package:flutter/foundation.dart';
//import 'package:get_ip_address/get_ip_address.dart';

class NetworkUtils  {
  // static Future<String?> getIPv4Address() async {
  //   try {
  //     /// Initialize Ip Address
  //     var ipAddress = IpAddress(type: RequestType.json);
  //
  //     /// Get the IpAddress based on requestType.
  //     dynamic data = await ipAddress.getIpAddress();
  //     print(data.toString());
  //   } on IpAddressException catch (exception) {
  //     /// Handle the exception.
  //     print(exception.message);
  //   }
  // }

  // static Future<String?> getIPv4Address() async {
  //   String tempIpv4 = "";
  //   String tempIpv6 = "";
  //   try {
  //     // 获取所有网络接口信息
  //     List<NetworkInterface> interfaces = await NetworkInterface.list(
  //       includeLoopback: true, // 是否包含回环接口
  //       includeLinkLocal: true, // 是否包含链路本地接口（例如IPv6的自动配置地址）。
  //       type: InternetAddressType.any,
  //     );
  //     print('getIPv4Address: ${interfaces.length}');
  //     // 遍历所有网络接口
  //     for (var interface in interfaces) {
  //       print('interface.name: ${interface.name}');
  //       // check if interface is en0 which is the wifi conection on the iphone
  //       // if (interface.name != 'en0') {
  //       //   continue;
  //       // }
  //       print('Interface name: ${interface.name} address size :${interface.addresses.length}');
  //       // 遍历接口的地址
  //       for (var address in interface.addresses) {
  //         print('interface.name: ${interface.name} address:${address.address}  type:${address.type}');
  //         if (address.address.isNotEmpty) {
  //           if (address.type == InternetAddressType.IPv4) {
  //             tempIpv4 = address.address;
  //             if (kDebugMode) {
  //               print('IPv4 address: $tempIpv4');
  //             }
  //           } else if (address.type == InternetAddressType.IPv6) {
  //             tempIpv6 = address.address;
  //             if (tempIpv6.contains("%en0")) {
  //               tempIpv6 = tempIpv6.replaceAll("%en0", "");
  //             }
  //
  //             if (kDebugMode) {
  //               print('IPv6 address: $tempIpv6');
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Failed to get IP addresses: $e');
  //   }
  //   return tempIpv4;
  // }
}