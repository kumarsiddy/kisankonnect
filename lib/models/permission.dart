import 'package:flutter/cupertino.dart';

class Permission {
  String permission;
  String errorCode;
  String errorMessage;
  bool isGranted;
  bool isNeverClicked;

  Permission(
      {@required this.permission,
      this.errorCode,
      this.errorMessage,
      this.isGranted,
      this.isNeverClicked});
}
