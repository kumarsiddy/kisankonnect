import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kisankonnect/src/resources/colors.dart';
import 'package:kisankonnect/utils/app_utils.dart';

class CustomSnackbar {
  static void showInfo(BuildContext context, String message,
      {String title, Widget mainButton, isDismissible: true}) {
    _show(context, message,
        title: title,
        type: CustomSnackbarType.INFO,
        mainButton: mainButton,
        isDismissible: isDismissible);
  }

  static void showError(BuildContext context, String message,
      {String title, Widget mainButton, isDismissible: true}) {
    _show(context, message,
        title: title,
        type: CustomSnackbarType.ERROR,
        mainButton: mainButton,
        isDismissible: isDismissible);
  }

  static void _show(BuildContext context, String message,
      {String title,
      CustomSnackbarType type: CustomSnackbarType.INFO,
      Widget mainButton,
      bool isDismissible}) {
    AppUtils.hideKeyboard(context);
    Flushbar(
      isDismissible: isDismissible,
      title: title,
      message: message,
      icon: type.icon,
      duration: isDismissible ? Duration(seconds: 3) : null,
      backgroundColor: type.color,
      mainButton: mainButton,
      boxShadows: [
        BoxShadow(
          color: type.color.withOpacity(0.8),
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
    )..show(context);
  }
}

enum CustomSnackbarType {
  ERROR,
  INFO,
}

extension getColor on CustomSnackbarType {
  Color get color {
    switch (this) {
      case CustomSnackbarType.ERROR:
        return AppColor.RED.color;
      case CustomSnackbarType.INFO:
        return AppColor.PRIMARY.color;
      default:
        return null;
    }
  }

  Icon get icon {
    switch (this) {
      case CustomSnackbarType.ERROR:
        return Icon(
          Icons.error_outline,
          size: 28.0,
          color: AppColor.WHITE.color,
        );
      default:
        return null;
    }
  }
}
