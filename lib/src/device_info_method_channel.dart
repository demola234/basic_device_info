import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info/src/models/device_info_model.dart';
import 'device_info_platform_interface.dart';

class MethodChannelDeviceInfo extends DeviceInfoPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('com.deviceinfo/channel');

  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
    try {
      final result = await methodChannel.invokeMethod<Map>('getDeviceInfo');
      final map = Map<String, dynamic>.from(result ?? {});
      return DeviceInfoModel.fromMap(map);
    } on PlatformException catch (e) {
      throw Exception('Failed to get device info: ${e.message}');
    }
  }
}