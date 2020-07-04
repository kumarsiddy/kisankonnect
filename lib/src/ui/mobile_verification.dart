import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kisankonnect/blocs/otp_bloc.dart';
import 'package:kisankonnect/models/otp_models.dart';
import 'package:kisankonnect/src/customview/loader.dart';
import 'package:kisankonnect/src/customview/snackbar.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:kisankonnect/utils/routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MobileVerification extends StatefulWidget {
  static const String MOBILE = 'mobile';

  @override
  State<StatefulWidget> createState() {
    return _MobileVerificationState();
  }
}

class _MobileVerificationState extends State<MobileVerification> {
  int remainingTime = 30;
  Timer timer;
  String mobile;
  ProgressDialog progressDialog;
  bool isResendBtnEnabled = false;
  bool isValidateBtnEnabled = false;
  String otp;
  BuildContext scaffoldContext;

  @override
  void initState() {
    super.initState();
    sendOtp();
    initListenerForOtp();
  }

  sendOtp() {
    progressDialog = Loader.getInstance(context);
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => progressDialog.show().then((value) => otpBloc.getOtp(mobile)));
  }

  initListenerForOtp() {
    otpBloc.otpStream.listen((otpResponse) {
      progressDialog.hide();
      if (otpResponse != null && otpResponse.isSuccess) {
        processOtpValidation(otpResponse);
      } else {
        CustomSnackbar.showError(context, otpResponse.message);
      }
    }).onError((error) => progressDialog.hide());
  }

  startResendTimer() {
    // Making resend button disabled before starting countdown
    validateResendBtn(false);
    // Resetting time back 30
    remainingTime = 30;
    timer = new Timer.periodic(new Duration(seconds: 1), (time) {
      setState(() {
        remainingTime -= 1;
      });
      if (remainingTime == 0) {
        time.cancel();
        validateResendBtn(true);
      }
    });
  }

  validateResendBtn(bool shouldBeEnabled) {
    setState(() {
      isResendBtnEnabled = shouldBeEnabled;
    });
  }

  processOtpValidation(OtpResponse otpResponse) {
    switch (otpResponse.otpStatus) {
      case OtpStatus.GET:
        startResendTimer();
        break;
      case OtpStatus.VALIDATE:
        CustomSnackbar.showInfo(scaffoldContext, AppString.otp_verified);
        RouteManager.navigateToOnly(context, ScreenType.DASHBOARD);
        break;
      case OtpStatus.RESEND:
        startResendTimer();
        break;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    otpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    mobile = args[MobileVerification.MOBILE];

    return CustomScreenBg(
        AppString.verify_number, CustomCard(getOtpVerificationPage()));
  }

  getOtpVerificationPage() {
    return Builder(
      builder: (context) {
        scaffoldContext = context;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TitleText(AppString.verify_number),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: AppString.otp_sent,
                      style:
                          TextStyle(color: AppColor.GRAY.color, fontSize: 18),
                      children: [
                        TextSpan(
                          text: mobile,
                          style: TextStyle(
                            color: AppColor.PRIMARY.color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    iconSize: 20,
                    icon: Icon(
                      Icons.edit,
                      color: AppColor.PRIMARY.color,
                    ),
                    onPressed: onEditMobile,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: PinCodeTextField(
                  length: 6,
                  obsecureText: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  onCompleted: onOtpEntered,
                  onChanged: (value) {
                    if (value.length < 6) {
                      setState(() {
                        isValidateBtnEnabled = false;
                      });
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24, bottom: 24, left: 12, right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getResendWidget(),
                  CustomButton(
                    AppString.verify,
                    isValidateBtnEnabled ? onValidate : null,
                    textColor: AppColor.WHITE.color,
                    bgColor: AppColor.PRIMARY.color,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget getResendWidget() {
    if (isResendBtnEnabled) {
      return CustomButton(
        AppString.resend,
        onResend,
        textColor: AppColor.WHITE.color,
        bgColor: AppColor.PRIMARY.color,
      );
    }
    return RichText(
      text: TextSpan(
        text: 'Resend in ${remainingTime}s',
        style: TextStyle(color: AppColor.GRAY.color, fontSize: 18),
      ),
    );
  }

  onResend() {
    progressDialog.show().then((_) {
      otpBloc.resendOtp(mobile);
    });
  }

  onOtpEntered(String otp) {
    setState(() {
      isValidateBtnEnabled = true;
    });
    this.otp = otp;
  }

  onEditMobile() {
    RouteManager.replaceWith(context, ScreenType.MOBILE_ENTRY, args: {
      MobileVerification.MOBILE: mobile,
    });
  }

  onValidate() {
    if (otp?.length == 6) {
      progressDialog.show().then((_) {
        otpBloc.validateOtp(mobile, otp);
      });
    } else {
      CustomSnackbar.showError(scaffoldContext, AppString.error_otp);
    }
  }
}
