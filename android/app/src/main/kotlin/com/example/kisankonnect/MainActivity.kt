package com.example.kisankonnect

import android.Manifest
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : PermissionActivity() {
    private val channel = "location_permission_channel"
    private val locationPermission = "getLocationPermission"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == locationPermission) {
                checkPermission(Manifest.permission.ACCESS_FINE_LOCATION) { it ->
                    if (it.isGranted) {
                        LocationService.getLocation(this) {
                            result.success(true);
                        };
                    } else {
                        result.error(it.permissionStatus.name, "Permission is not granted", null)
                    }
                };
            } else {
                result.notImplemented()
            }
        }
    }
}
