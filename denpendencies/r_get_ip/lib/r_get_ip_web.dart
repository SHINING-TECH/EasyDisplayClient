import 'dart:async';
import 'dart:convert';

// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the RGetIp plugin.
class RGetIpWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'r_get_ip',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = RGetIpWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getNetworkType':
        return "wired";
      case 'getInternalIP':
        return "127.0.0.1";
      case 'getExternalIP':
        Completer<String> completer = Completer();
        var xhr = html.HttpRequest()
          ..open('GET', 'https://api.ipify.org/?format=json', async: true)
          ..withCredentials = false;
        xhr.onLoad.first.then((value) {
          var blob = xhr.response ?? html.Blob([]);
          if (blob is String) {
            completer.complete(blob);
          } else {
            completer.complete('0.0.0.0');
          }
        });
        xhr.send();
        String result = await completer.future;
        final map = json.decode(result);
        return map['ip'];
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'r_get_ip for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
}
