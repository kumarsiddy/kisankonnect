import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kisankonnect/blocs/updateuser_bloc.dart';
import 'package:kisankonnect/models/updateuser_model.dart';
import 'package:kisankonnect/src/customview/loader.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:kisankonnect/src/ui/mobile_verification.dart';
import 'package:kisankonnect/utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MobileEntry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MobileEntryState();
  }
}

class _MobileEntryState extends State<MobileEntry> {
  static const MOBILE = 'mobile';

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool autoValidate = true;
  String previousMobile;
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    progressDialog = Loader.getInstance(context);
    initListenerForSavingMobile();
  }

  initListenerForSavingMobile() {
    updateUserBloc.saveMobileStream
        .listen((UpdateUserResponse updateUserResponse) {
      progressDialog.hide();
      if (updateUserResponse != null && updateUserResponse.isSuccess) {
        RouteManager.replaceWith(context, ScreenType.MOBILE_VERIFICATION,
            args: {
              MobileVerification.MOBILE: _fbKey.currentState.value[MOBILE],
            });
      }
    }).onError((_) => progressDialog.hide());
  }

  @override
  void dispose() {
    super.dispose();
    updateUserBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    previousMobile = args[MobileVerification.MOBILE];

    return CustomScreenBg(
      AppString.verify_number,
      CustomCard(getMobileVerificationView(context)),
    );
  }

  getMobileVerificationView(BuildContext context) {
    return FormBuilder(
      key: _fbKey,
      autovalidate: autoValidate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TitleText(AppString.verify_number),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SubTitleText(AppString.enter_phone),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 16),
            child: FormBuilderTextField(
              attribute: MOBILE,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone_android),
              ),
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.phone,
              initialValue: previousMobile,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(10),
              ],
              validators: [
                FormBuilderValidators.minLength(10),
                FormBuilderValidators.maxLength(10),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),
                child: CustomButton(
                  AppString.send_otp,
                  onSendOtp,
                  textColor: AppColor.WHITE.color,
                  bgColor: AppColor.PRIMARY.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onSendOtp() {
    if (_fbKey.currentState.saveAndValidate()) {
      progressDialog.show().then((_) {
        updateUserBloc.saveMobile(_fbKey.currentState.value[MOBILE]);
      });
    }
  }
}
