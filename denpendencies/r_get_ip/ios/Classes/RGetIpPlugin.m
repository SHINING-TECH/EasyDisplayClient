#import "RGetIpPlugin.h"
#if __has_include(<r_get_ip/r_get_ip-Swift.h>)
#import <r_get_ip/r_get_ip-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "r_get_ip-Swift.h"
#endif

@implementation RGetIpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRGetIpPlugin registerWithRegistrar:registrar];
}
@end
