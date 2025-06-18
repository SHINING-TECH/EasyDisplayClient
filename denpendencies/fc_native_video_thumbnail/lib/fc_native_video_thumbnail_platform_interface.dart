import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fc_native_video_thumbnail_method_channel.dart';

abstract class FcNativeVideoThumbnailPlatform extends PlatformInterface {
  /// Constructs a FcNativeVideoThumbnailPlatform.
  FcNativeVideoThumbnailPlatform() : super(token: _token);

  static final Object _token = Object();

  static FcNativeVideoThumbnailPlatform _instance =
      MethodChannelFcNativeVideoThumbnail();

  /// The default instance of [FcNativeVideoThumbnailPlatform] to use.
  ///
  /// Defaults to [MethodChannelFcNativeVideoThumbnail].
  static FcNativeVideoThumbnailPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FcNativeVideoThumbnailPlatform] when
  /// they register themselves.
  static set instance(FcNativeVideoThumbnailPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> getVideoThumbnail(
      {required String srcFile,
      required String destFile,
      required int width,
      required int height,
      String? format,
      bool? srcFileUri,
      int? quality}) {
    throw UnimplementedError('getVideoThumbnail() has not been implemented.');
  }
}
