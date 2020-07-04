import 'package:flutter/material.dart';

enum AppColor {
  PRIMARY,
  PRIMARY_DARK,
  ACCENT,
  WHITE,
  SNOW_WHITE,
  TRANSPARENT,
  PRIMARY_TRANSPARENT,
  BLACK,
  GRAY,
  RED,
}

extension AppColorExtension on AppColor {
  Color get color {
    switch (this) {
      case AppColor.PRIMARY:
        return Color(0xff00BE82);
      case AppColor.PRIMARY_DARK:
        return Color(0xff00BE82);
      case AppColor.ACCENT:
        return Colors.white;
      case AppColor.WHITE:
        return Colors.white;
      case AppColor.SNOW_WHITE:
        return Color(0xffF2F2F2);
      case AppColor.TRANSPARENT:
        return Colors.transparent;
      case AppColor.PRIMARY_TRANSPARENT:
        return Color(0x8000BE82);
      case AppColor.BLACK:
        return Colors.black;
      case AppColor.RED:
        return Colors.redAccent;
      case AppColor.GRAY:
        return Color(0xff808589);
      default:
        return null;
    }
  }
}
