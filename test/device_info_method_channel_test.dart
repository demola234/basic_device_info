import 'package:device_info/src/models/device_info_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_info/src/device_info_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDeviceInfo platform = MethodChannelDeviceInfo();
  const MethodChannel channel = MethodChannel('com.deviceinfo/channel');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return <String, dynamic>{
          'carrier': 'Test-Carrier',
          'wifi': false,
          'bluetoothEnabled': true,
          'radio': true,
          'hasNfc': true,
          'ussdChannel': false,
        };
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getDeviceInfo(), DeviceInfoModel(
      carrier: 'Test-Carrier',
      wifi: false,
      bluetoothEnabled: true,
      radio: true,
      hasNfc: true,
      ussdChannel: false,
    ));
  });
}