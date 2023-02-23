#include "include/real_stepper/real_stepper_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "real_stepper_plugin.h"

void RealStepperPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  real_stepper::RealStepperPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
