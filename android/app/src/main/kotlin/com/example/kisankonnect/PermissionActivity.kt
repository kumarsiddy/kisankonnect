package com.example.kisankonnect

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.example.kisankonnect.models.Permission
import com.example.kisankonnect.models.PermissionStatus
import io.flutter.embedding.android.FlutterActivity

abstract class PermissionActivity : FlutterActivity() {

    private var readStoragePermissionId = 1001
    private val writeStoragePermissionId = 1002
    private val locationPermissionId = 1003
    private val cameraPermissionId = 1004

    private lateinit var permissionListener: (permission: Permission) -> Unit

    protected fun checkPermission(
            permission: String,
            permissionListener: (permission: Permission) -> Unit
    ) {
        this.permissionListener = permissionListener
        checkPermission(permission)
    }

    private fun getPermissionId(permission: String): Int {
        when (permission) {
            Manifest.permission.READ_EXTERNAL_STORAGE -> return readStoragePermissionId
            Manifest.permission.WRITE_EXTERNAL_STORAGE -> return writeStoragePermissionId
            Manifest.permission.ACCESS_FINE_LOCATION -> return locationPermissionId
            Manifest.permission.CAMERA -> return cameraPermissionId
        }
        throw RuntimeException("Permission is not Defined.")
    }

    private fun checkPermission(permission: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
                && ContextCompat.checkSelfPermission(
                        this,
                        permission
                ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(
                    arrayOf(permission),
                    getPermissionId(permission)
            )
        } else {
            permissionListener(Permission(permission, true))
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        // if request is cancelled, the result arrays are empty,
        // hence a check on length is required
        if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            permissionListener(Permission(permissions[0], true))
        } else if (permissions.isNotEmpty()) {
            if (!shouldShowRequestPermissionRationale(permissions[0])) {
                permissionListener(Permission(permissions[0], isGranted = false, permissionStatus = PermissionStatus.NEVER_ALLOWED_CLICKED))
            } else permissionListener(Permission(permissions[0], isGranted = false, permissionStatus = PermissionStatus.REJECTED))
        } else permissionListener(Permission(permissions[0], true))
    }
}