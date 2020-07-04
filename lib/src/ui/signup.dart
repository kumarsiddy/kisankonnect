import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kisankonnect/blocs/signup_bloc.dart';
import 'package:kisankonnect/models/gender.dart';
import 'package:kisankonnect/models/signup_models.dart';
import 'package:kisankonnect/sharedprefs/shared_prefs.dart';
import 'package:kisankonnect/src/customview/loader.dart';
import 'package:kisankonnect/src/customview/snackbar.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:kisankonnect/src/ui/mobile_verification.dart';
import 'package:kisankonnect/utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  static const NAME = 'name';
  static const GENDER = 'gender';
  static const EMAIL = 'email';
  static const MOBILE = 'mobile';
  static const PASSWORD = 'password';
  static const CONFIRM_PASSWORD = 'confirm_password';

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _autoValidate = true;
  ProgressDialog progressDialog;
  BuildContext scaffoldContext;
  String mobile;

  @override
  void initState() {
    super.initState();
    progressDialog = Loader.getInstance(context);
    initListenerForSignup();
  }

  initListenerForSignup() {
    signupBloc.signupStream.listen((SignUpResponse signUpResponse) {
      progressDialog.hide();
      if (signUpResponse != null && signUpResponse.isSuccess) {
        LocalCache.getInstance().saveToken(signUpResponse.token);
        RouteManager.replaceWith(context, ScreenType.MOBILE_VERIFICATION,
            args: {
              MobileVerification.MOBILE: mobile,
            });
      } else {
        CustomSnackbar.showError(scaffoldContext, signUpResponse.message);
      }
    }).onError((error) => progressDialog.hide());
  }

  @override
  void dispose() {
    super.dispose();
    signupBloc.dispose();
  }

  onSubmit() {
    if (_fbKey.currentState.saveAndValidate()) {
      progressDialog.show().then((_) {
        final String name = _fbKey.currentState.value[NAME];
        final Gender gender = _fbKey.currentState.value[GENDER];
        final String email = _fbKey.currentState.value[EMAIL];
        final String password = _fbKey.currentState.value[PASSWORD];
        mobile = _fbKey.currentState.value[MOBILE];

        signupBloc.singUp(
          name: name,
          gender: gender,
          email: email,
          mobile: mobile,
          password: password,
        );
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getSignupForm(BuildContext context) {
      final TextEditingController _passController = TextEditingController();

      return Builder(
        builder: (context) {
          scaffoldContext = context;

          return Padding(
            padding: EdgeInsets.all(12),
            child: FormBuilder(
              key: _fbKey,
              autovalidate: _autoValidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: AppString.welcome_to,
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
                      SubTitleText(AppString.lets_get_started),
                    ],
                  ),
                  SizedBox(height: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: NAME,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: AppString.enter_name,
                        ),
                        keyboardType: TextInputType.text,
                        validators: [
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.maxLength(50),
                        ],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      SizedBox(height: 16),
                      SubTitleText(AppString.select_gender),
                      FormBuilderChoiceChip(
                        attribute: GENDER,
                        selectedColor: AppColor.PRIMARY.color,
                        backgroundColor: AppColor.GRAY.color,
                        spacing: 16,
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        options: [
                          FormBuilderFieldOption(
                            child: SubTitleText(
                              AppString.male,
                              color: AppColor.WHITE.color,
                            ),
                            value: Gender.MALE,
                          ),
                          FormBuilderFieldOption(
                            child: SubTitleText(
                              AppString.female,
                              color: AppColor.WHITE.color,
                            ),
                            value: Gender.FEMALE,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
                        attribute: EMAIL,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: AppString.enter_email,
                        ),
                        keyboardType: TextInputType.text,
                        validators: [
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.maxLength(50),
                          FormBuilderValidators.email(
                              errorText: AppString.error_email),
                        ],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
                        attribute: MOBILE,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: AppString.enter_phone,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        validators: [
                          FormBuilderValidators.minLength(10,
                              errorText: AppString.error_phone),
                          FormBuilderValidators.maxLength(10,
                              errorText: AppString.error_phone),
                          FormBuilderValidators.numeric(),
                        ],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
                        attribute: PASSWORD,
                        controller: _passController,
                        textInputAction: TextInputAction.next,
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
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
                        attribute: CONFIRM_PASSWORD,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: AppString.enter_confirm_password,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validators: [
                          FormBuilderValidators.minLength(5,
                              errorText: AppString.error_password),
                          (value) {
                            if (value != _passController.text) {
                              return AppString.error_not_matching_password;
                            }
                            return null;
                          },
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomButton(
                        AppString.sign_up,
                        onSubmit,
                      ),
                    ],
                  ),
                  SizedBox(height: 12)
                ],
              ),
            ),
          );
        },
      );
    }

    return CustomScreenBg(
      AppString.additional_information,
      CustomCard(getSignupForm(context)),
    );
  }
}
