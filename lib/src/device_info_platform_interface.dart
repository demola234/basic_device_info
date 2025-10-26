import 'package:device_info/src/models/device_info_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'device_info_method_channel.dart';

abstract class DeviceInfoPlatform extends PlatformInterface {
  DeviceInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceInfoPlatform _instance = MethodChannelDeviceInfo();

  static DeviceInfoPlatform get instance => _instance;

  static set instance(DeviceInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<DeviceInfoModel> getDeviceInfo() {
    throw UnimplementedError('getDeviceInfo() has not been implemented.');
  }
}