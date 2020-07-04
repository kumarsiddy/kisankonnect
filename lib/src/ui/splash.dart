import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kisankonnect/blocs/splash_bloc.dart';
import 'package:kisankonnect/sharedprefs/shared_prefs.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:kisankonnect/src/ui/check_pincode_widget.dart';
import 'package:kisankonnect/src/ui/mobile_verification.dart';
import 'package:kisankonnect/utils/network_manager.dart';
import 'package:kisankonnect/utils/routes.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isUserStatusLoading = true;

  @override
  void initState() {
    super.initState();
    _initNetworkChangeListener();
    _getUserStatus();
    _listenForStatusChange();
  }

  _initNetworkChangeListener() {
    NetworkManager.getInstance().connectionChangeStream.listen((isConnected) {
      if (!isConnected)
        RouteManager.navigateTo(context, ScreenType.NO_INTERNET);
    });
  }

  _getUserStatus() async {
    if ((await LocalCache.getInstance().getToken()) != null) {
      splashBloc.getUserStatus();
    } else {
      changeUserStatusFlag(false);
    }
  }

  _listenForStatusChange() {
    splashBloc.userStatusStream.listen((userStatus) {
      if (userStatus != null && userStatus.isSuccess) {
        LocalCache.getInstance().saveUserStatus(userStatus);
        SchedulerBinding.instance.addPostFrameCallback((_) =>
            RouteManager.replaceWith(context, userStatus.screenTypeToOpen,
                args: {
                  MobileVerification.MOBILE: userStatus.mobile,
                }));
      }
    });
  }

  changeUserStatusFlag(bool isUserStatusLoaded) {
    setState(() {
      this.isUserStatusLoading = isUserStatusLoaded;
    });
  }

  @override
  void dispose() {
    splashBloc.dispose();
    super.dispose();
  }

  onSignIn() {
    RouteManager.navigateTo(context, ScreenType.SIGN_IN);
  }

  onSignUp() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CheckPincode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.PRIMARY.color,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: new BoxDecoration(
                    color: AppColor.WHITE.color,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.WHITE.color.withOpacity(0.2),
                        spreadRadius: 8,
                        blurRadius: 8,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'KK',
                        style: TextStyle(
                          color: AppColor.PRIMARY.color,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 32, top: 16, left: 16, right: 16),
                    child: RichText(
                      text: TextSpan(
                        text: AppString.welcome_to,
                        style: TextStyle(
                          color: AppColor.WHITE.color,
                          fontSize: 32,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\n${AppString.app_name}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getSplashBottomViewWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSplashBottomViewWidget() {
    if (isUserStatusLoading) {
      return CircularProgressIndicator();
    }
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 16, bottom: 8),
          child: CustomButton(
            AppString.sign_in,
            onSignIn,
            textColor: AppColor.PRIMARY.color,
            bgColor: AppColor.WHITE.color,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          color: AppColor.TRANSPARENT.color,
          child: InkWell(
            onTap: onSignUp,
            child: RichText(
              text: TextSpan(
                text: AppString.sign_up,
                style: TextStyle(fontSize: 16, color: AppColor.WHITE.color),
              ),
            ),
          ),
        )
      ],
    );
  }
}
