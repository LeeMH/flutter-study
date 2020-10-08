package com.example.channel_example

import android.os.BatteryManager
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

const val METHOD_BATTERY = "getBatteryLevel";
const val CHANNEL_BATTERY = "android/battery";

class MainActivity: FlutterActivity() {


    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor, CHANNEL_BATTERY).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (METHOD_BATTERY == call.method) {
                val manager = getSystemService(BATTERY_SERVICE) as BatteryManager
                val battery = manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                result.success(battery)
            }
            result.notImplemented()
        }
    }
}
