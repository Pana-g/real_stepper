#ifndef FLUTTER_PLUGIN_REAL_STEPPER_PLUGIN_H_
#define FLUTTER_PLUGIN_REAL_STEPPER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace real_stepper {

class RealStepperPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RealStepperPlugin();

  virtual ~RealStepperPlugin();

  // Disallow copy and assign.
  RealStepperPlugin(const RealStepperPlugin&) = delete;
  RealStepperPlugin& operator=(const RealStepperPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace real_stepper

#endif  // FLUTTER_PLUGIN_REAL_STEPPER_PLUGIN_H_
