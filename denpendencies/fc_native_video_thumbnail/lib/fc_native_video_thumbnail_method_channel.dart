import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fc_native_video_thumbnail_platform_interface.dart';

/// An implementation of [FcNativeVideoThumbnailPlatform] that uses method channels.
class MethodChannelFcNativeVideoThumbnail
    extends FcNativeVideoThumbnailPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fc_native_video_thumbnail');

  @override
  Future<bool> getVideoThumbnail(
      {required String srcFile,
      required String destFile,
      required int width,
      required int height,
      String? format,
      bool? srcFileUri,
      int? quality}) async {
    var formatValue =
        format ?? (srcFile.toLowerCase().endsWith('.png') ? 'png' : 'jpeg');
    if (width <= 0 && height <= 0) {
      throw ArgumentError('Invalid width and height');
    }
    return (await methodChannel.invokeMethod<bool?>('getVideoThumbnail', {
          'srcFile': srcFile,
          'srcFileUri': srcFileUri,
          'destFile': destFile,
          'width': width,
          'height': height,
          'format': formatValue,
          'quality': quality,
        })) ??
        false;
  }
}
