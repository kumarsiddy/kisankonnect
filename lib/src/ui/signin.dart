import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kisankonnect/blocs/signin_bloc.dart';
import 'package:kisankonnect/models/signin_models.dart';
import 'package:kisankonnect/sharedprefs/shared_prefs.dart';
import 'package:kisankonnect/src/customview/loader.dart';
import 'package:kisankonnect/src/customview/snackbar.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:kisankonnect/utils/logger.dart';
import 'package:kisankonnect/utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  static const EMAIL = 'email_or_phone';
  static const PASSWORD = 'password';

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _autoValidate = true;
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    progressDialog = Loader.getInstance(context);
    initSigninStreamListener();
  }

  initSigninStreamListener() {
    signinBloc.signinStream.listen((SignInResponse signInResponse) {
      progressDialog.hide();
      Logger.d(signInResponse.message);
      Logger.d(signInResponse.isSuccess.toString());
      if (signInResponse != null && signInResponse.isSuccess) {
        LocalCache.getInstance().saveToken(signInResponse.token);
        RouteManager.navigateToOnly(context, ScreenType.DASHBOARD);
      } else {
        CustomSnackbar.showError(context, signInResponse.message);
      }
    }).onError((error) => progressDialog.hide());
  }

  @override
  void dispose() {
    super.dispose();
    signinBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenBg(
      AppString.sign_in,
      CustomCard(getSignInForm(context)),
    );
  }

  onSubmit() {
    if (_fbKey.currentState.saveAndValidate()) {
      progressDialog.show().then((_) {
        final username = _fbKey.currentState.value[EMAIL];
        final password = _fbKey.currentState.value[PASSWORD];
        signinBloc.signin(username, password);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  onForgetPassword() {}

  getSignInForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: FormBuilder(
        key: _fbKey,
        autovalidate: _autoValidate,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: AppString.sign_in_to,
                      style: TextStyle(
                        color: AppColor.BLACK.color,
                        fontSize: 18,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${AppString.app_name}',
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColor.PRIMARY.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SubTitleText(AppString.enter_email_or_phone_to_continue),
                ],
              ),
              SizedBox(height: 16),
              FormBuilderTextField(
                attribute: EMAIL,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: AppString.enter_email_or_phone,
                ),
                keyboardType: TextInputType.text,
                validators: [
                  FormBuilderValidators.minLength(3),
                  FormBuilderValidators.maxLength(50),
                  (value) {
                    if (value.contains('@') || value.length == 10) {
                      return null;
                    }
                    return AppString.error_phone_or_email;
                  },
                ],
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 16),
              FormBuilderTextField(
                attribute: PASSWORD,
                textInputAction: TextInputAction.done,
                obscureText: true,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: AppString.enter_password,
                ),
                keyboardType: TextInputType.visiblePassword,
                validators: [
                  FormBuilderValidators.minLength(5,
                      errorText: AppString.error_password),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: onForgetPassword,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 8, top: 8, left: 12, right: 12),
                      child: SubTitleText(AppString.forgot_password),
                    ),
                  ),
                  CustomButton(
                    AppString.sign_in,
                    onSubmit,
                  ),
                ],
              ),
              SizedBox(height: 12)
            ]),
      ),
    );
  }
}
