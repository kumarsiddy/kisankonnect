import 'package:flutter/material.dart';
import 'package:kisankonnect/src/resources/colors.dart';

class CustomButton extends StatelessWidget {
  final String btnText;
  final onButtonClick;
  final Color textColor;
  final Color bgColor;

  CustomButton(
    this.btnText,
    this.onButtonClick, {
    this.textColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 120.0,
      height: 40.0,
      buttonColor: bgColor ?? AppColor.PRIMARY.color,
      child: RaisedButton(
        child: RichText(
          text: TextSpan(
            text: btnText,
            style: TextStyle(
              color: textColor ?? AppColor.WHITE.color,
              fontSize: 16.0,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onPressed: onButtonClick,
      ),
    );
  }
}
