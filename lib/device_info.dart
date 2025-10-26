library device_info;

import 'package:device_info/device_info.dart';

import 'src/device_info_platform_interface.dart';

export 'src/models/device_info_model.dart';

class DeviceInfo {
  Future<DeviceInfoModel> getDeviceInfo() {
    return DeviceInfoPlatform.instance.getDeviceInfo();
  }
}