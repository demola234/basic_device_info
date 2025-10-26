package com.example.device_info

import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.telephony.TelephonyManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class DeviceInfoPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.deviceinfo/channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDeviceInfo" -> {
                try {
                    result.success(getDeviceInfo())
                } catch (e: Exception) {
                    result.error("ERROR", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun getDeviceInfo(): Map<String, Any> {
        return mapOf(
            "carrier" to getCarrier(),
            "wifi" to isWifiConnected(),
            "bluetooth_enabled" to isBluetoothEnabled(),
            "radio" to isCellularConnected(),
            "has_nfc" to hasNfc(),
            "ussd_channel" to hasUssdChannel()
        )
    }

    private fun getCarrier(): String {
        return try {
            val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
            telephonyManager?.networkOperatorName?.takeIf { it.isNotEmpty() } ?: "Unknown"
        } catch (e: Exception) {
            "Unknown"
        }
    }

    private fun isWifiConnected(): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
            ?: return false

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork ?: return false
            val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return false
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
        } else {
            @Suppress("DEPRECATION")
            connectivityManager.activeNetworkInfo?.type == ConnectivityManager.TYPE_WIFI
        }
    }

    private fun isCellularConnected(): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
            ?: return false

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork ?: return false
            val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return false
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)
        } else {
            @Suppress("DEPRECATION")
            connectivityManager.activeNetworkInfo?.type == ConnectivityManager.TYPE_MOBILE
        }
    }

    private fun isBluetoothEnabled(): Boolean {
        return try {
            BluetoothAdapter.getDefaultAdapter()?.isEnabled ?: false
        } catch (e: Exception) {
            false
        }
    }

    private fun hasNfc(): Boolean {
        return context.packageManager.hasSystemFeature(PackageManager.FEATURE_NFC)
    }

    private fun hasUssdChannel(): Boolean {
        return try {
            val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
            telephonyManager != null && telephonyManager.phoneType != TelephonyManager.PHONE_TYPE_NONE
        } catch (e: Exception) {
            false
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}