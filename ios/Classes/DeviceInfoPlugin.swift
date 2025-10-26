import Flutter
import UIKit
import CoreTelephony
import SystemConfiguration
import CoreBluetooth

public class DeviceInfoPlugin: NSObject, FlutterPlugin {
    private var bluetoothManager: CBCentralManager?
    private var isBluetoothOn = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.deviceinfo/channel",
            binaryMessenger: registrar.messenger()
        )
        let instance = DeviceInfoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getDeviceInfo" {
            result(getDeviceInfo())
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func getDeviceInfo() -> [String: Any] {
        return [
            "carrier": getCarrier(),
            "wifi": isWifiConnected(),
            "bluetooth_enabled": checkBluetooth(),
            "radio": isCellularConnected(),
            "has_nfc": hasNFC(),
            "ussd_channel": hasUssdChannel()
        ]
    }

    private func getCarrier() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            if let carrier = networkInfo.serviceSubscriberCellularProviders?.values.first {
                return carrier.carrierName ?? "Unknown"
            }
        } else {
            if let carrier = networkInfo.subscriberCellularProvider {
                return carrier.carrierName ?? "Unknown"
            }
        }
        return "Unknown"
    }

    private func isWifiConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)

        return isReachable && !isWWAN
    }

    private func isCellularConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)

        return isReachable && isWWAN
    }

    private func checkBluetooth() -> Bool {
        if bluetoothManager == nil {
            bluetoothManager = CBCentralManager(delegate: self, queue: nil)
        }
        return isBluetoothOn
    }

    private func hasNFC() -> Bool {
        if #available(iOS 11.0, *) {
            return true
        }
        return false
    }

    private func hasUssdChannel() -> Bool {
        let networkInfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            return networkInfo.serviceSubscriberCellularProviders?.isEmpty == false
        } else {
            return networkInfo.subscriberCellularProvider != nil
        }
    }
}

extension DeviceInfoPlugin: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothOn = central.state == .poweredOn
    }
}