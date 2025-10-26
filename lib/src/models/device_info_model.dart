class DeviceInfoModel {
  final String carrier;
  final bool wifi;
  final bool bluetoothEnabled;
  final bool radio;
  final bool hasNfc;
  final bool ussdChannel;

  const DeviceInfoModel({
    required this.carrier,
    required this.wifi,
    required this.bluetoothEnabled,
    required this.radio,
    required this.hasNfc,
    required this.ussdChannel,
  });

  factory DeviceInfoModel.fromMap(Map<String, dynamic> map) {
    return DeviceInfoModel(
      carrier: map['carrier']?.toString() ?? '',
      wifi: map['wifi'] is bool ? map['wifi'] as bool : (map['wifi'] == 1),
      bluetoothEnabled: map['bluetoothEnabled'] is bool
          ? map['bluetoothEnabled'] as bool
          : (map['bluetoothEnabled'] == 1),
      radio: map['radio'] is bool ? map['radio'] as bool : (map['radio'] == 1),
      hasNfc:
      map['hasNfc'] is bool ? map['hasNfc'] as bool : (map['hasNfc'] == 1),
      ussdChannel: map['ussdChannel'] is bool
          ? map['ussdChannel'] as bool
          : (map['ussdChannel'] == 1),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carrier': carrier,
      'wifi': wifi,
      'bluetoothEnabled': bluetoothEnabled,
      'radio': radio,
      'hasNfc': hasNfc,
      'ussdChannel': ussdChannel,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfoModel &&
        other.carrier == carrier &&
        other.wifi == wifi &&
        other.bluetoothEnabled == bluetoothEnabled &&
        other.radio == radio &&
        other.hasNfc == hasNfc &&
        other.ussdChannel == ussdChannel;
  }

  @override
  int get hashCode =>
      Object.hash(carrier, wifi, bluetoothEnabled, radio, hasNfc, ussdChannel);

  @override
  String toString() {
    return 'DeviceInfoModel(carrier: $carrier, wifi: $wifi, bluetoothEnabled: $bluetoothEnabled, radio: $radio, hasNfc: $hasNfc, ussdChannel: $ussdChannel)';
  }
}
