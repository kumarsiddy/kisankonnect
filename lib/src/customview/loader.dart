import 'package:flutter/material.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Loader {
  static ProgressDialog getInstance(
    BuildContext context, {
    isDismissible = false,
    message = AppString.loading,
  }) {
    return new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: isDismissible,
      customBody: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.PRIMARY.color),
                backgroundColor: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SubTitleText(
                  message,
                  color: AppColor.PRIMARY.color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
