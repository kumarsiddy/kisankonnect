import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kisankonnect/models/permission.dart';
import 'package:kisankonnect/src/customview/button.dart';
import 'package:kisankonnect/src/customview/snackbar.dart';
import 'package:kisankonnect/src/resources/resources.dart';

class PlatformBridge {
  static const MethodChannel _locationPermissionChannel =
      const MethodChannel('location_permission_channel');

  static const LOCATION_PERMISSION = 'location';
  static const String defaultPermissionStatus = 'DEFAULT';
  static const String rejectedPermissionStatus = 'REJECTED';
  static const String neverAllowPermissionStatus = 'NEVER_ALLOWED_CLICKED';

  static Future<Permission> getLocationPermission(BuildContext context) async {
    try {
      final bool result = await _locationPermissionChannel
          .invokeMethod('getLocationPermission');
      return Permission(permission: LOCATION_PERMISSION, isGranted: result);
    } on PlatformException catch (error) {
      if (error.code == neverAllowPermissionStatus) {
        CustomSnackbar.showError(
            context, AppString.allow_location_permission_from_setting,
            title: AppString.location_permission,
            isDismissible: false,
            mainButton: CustomButton(
              AppString.open_setting,
              () {
                AppSettings.openAppSettings();
              },
              bgColor: AppColor.TRANSPARENT.color,
            ));
      } else if (error.code == rejectedPermissionStatus) {
        CustomSnackbar.showInfo(context, AppString.allow_location_permission,
            title: AppString.location_permission);
      }
    }

    return Permission(permission: LOCATION_PERMISSION, isGranted: false);
  }
}
