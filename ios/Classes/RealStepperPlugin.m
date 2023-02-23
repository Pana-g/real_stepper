#import "RealStepperPlugin.h"
#if __has_include(<real_stepper/real_stepper-Swift.h>)
#import <real_stepper/real_stepper-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "real_stepper-Swift.h"
#endif

@implementation RealStepperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRealStepperPlugin registerWithRegistrar:registrar];
}
@end
