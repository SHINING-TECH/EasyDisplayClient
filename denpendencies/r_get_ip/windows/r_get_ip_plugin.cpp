#include "include/r_get_ip/r_get_ip_plugin.h"
#include "include/r_get_ip/InitSock.h"
#pragma warning(disable: 4996)
// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>
CInitSock initsock;

namespace {

class RGetIpPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RGetIpPlugin();

  virtual ~RGetIpPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void RGetIpPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "r_get_ip",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<RGetIpPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

RGetIpPlugin::RGetIpPlugin() {}

RGetIpPlugin::~RGetIpPlugin() {}

void RGetIpPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getNetworkType") == 0) {
    std::ostringstream version_stream;
    version_stream << "wired";
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if (method_call.method_name().compare("getInternalIP") == 0) {
      char szhost[256];
      ::gethostname(szhost, 256);

      hostent* phost = ::gethostbyname(szhost);

      in_addr addr;
      for (int i = 0;; i++) {
          char* p = phost->h_addr_list[i];
          if (p == NULL)
              break;
          memcpy(&addr.S_un.S_addr, p, phost->h_length);
          char* slzp = ::inet_ntoa(addr);
          std::ostringstream version_stream;
          version_stream << slzp;
          result->Success(flutter::EncodableValue(version_stream.str()));
      }
  }else if (method_call.method_name().compare("getExternalIP") == 0) {
      char szhost[256];
      ::gethostname(szhost, 256);

      hostent* phost = ::gethostbyname(szhost);

      in_addr addr;
      for (int i = 0;; i++) {
          char* p = phost->h_addr_list[i];
          if (p == NULL)
              break;
          memcpy(&addr.S_un.S_addr, p, phost->h_length);
          char* slzp = ::inet_ntoa(addr);
          std::ostringstream version_stream;
          version_stream << slzp;
          result->Success(flutter::EncodableValue(version_stream.str()));
      }
  }else {
    result->NotImplemented();
  }
}

}  // namespace

void RGetIpPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  RGetIpPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

