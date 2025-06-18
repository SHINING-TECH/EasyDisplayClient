#include "include/fc_native_video_thumbnail/fc_native_video_thumbnail_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fc_native_video_thumbnail_plugin.h"

void FcNativeVideoThumbnailPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fc_native_video_thumbnail::FcNativeVideoThumbnailPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
