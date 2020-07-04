package com.example.kisankonnect.models

data class Permission(val permission: String, val isGranted: Boolean, val permissionStatus: PermissionStatus = PermissionStatus.DEFAULT)

enum class PermissionStatus {
    DEFAULT,
    REJECTED,
    NEVER_ALLOWED_CLICKED,
}