import 'package:device_info/device_info.dart';
import 'package:device_info/src/device_info_method_channel.dart';
import 'package:device_info/src/device_info_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceInfoPlatform
    with MockPlatformInterfaceMixin
    implements DeviceInfoPlatform {
  @override
  Future<DeviceInfoModel> getDeviceInfo() {
    return Future.value(
      DeviceInfoModel(
        carrier: 'Test-Carrier',
        wifi: false,
        bluetoothEnabled: true,
        radio: true,
        hasNfc: true,
        ussdChannel: false,
      ),
    );
  }
}

void main() {
  final DeviceInfoPlatform initialPlatform = DeviceInfoPlatform.instance;

  test('$MethodChannelDeviceInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeviceInfo>());
  });

  test('getDeviceInfoPlugin', () async {
    DeviceInfo deviceInfoPlugin = DeviceInfo();
    MockDeviceInfoPlatform fakePlatform = MockDeviceInfoPlatform();
    DeviceInfoPlatform.instance = fakePlatform;

    expect(
      await deviceInfoPlugin.getDeviceInfo(),
      DeviceInfoModel(
        carrier: 'Test-Carrier',
        wifi: false,
        bluetoothEnabled: true,
        radio: true,
        hasNfc: true,
        ussdChannel: false,
      ),
    );
  });
}
