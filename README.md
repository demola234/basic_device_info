# Device Info Plugin

A Flutter plugin that provides native device information (brand, model, OS version, etc.) from
Android and iOS using a custom MethodChannel.

This plugin serves as an example or foundation for adding platform-specific code in Flutter without
relying on third-party packages.

🚀 Features

Retrieve detailed Android and iOS device information.

Works via a single Dart API.

Built using Flutter Platform Channels.

📦 Installation

Add this plugin to your Flutter project (assuming it’s in a local folder):

```yaml
dependencies:
device_info:
  git:
    url: "https://github.com/demola234/basic_device_info.git"
    ref: "main"
```

Then run:

```bash
flutter pub get
```

🔧 Usage
Import the plugin and use it to get device information:

```dart
import 'package:device_info/device_info.dart';

void main() async {
  final deviceInfo = await DeviceInfo().getDeviceInfo();
  print('Device info: $deviceInfo');
}
```

Expected Output:

```json
{
  "brand": "Google",
  "model": "Pixel 6",
  "systemVersion": "Android 14"
}
```
