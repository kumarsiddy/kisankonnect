import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kisankonnect/src/ui/dashboard.dart';
import 'package:kisankonnect/src/ui/mobile_entry.dart';
import 'package:kisankonnect/src/ui/mobile_verification.dart';
import 'package:kisankonnect/src/ui/no_internet.dart';
import 'package:kisankonnect/src/ui/signin.dart';
import 'package:kisankonnect/src/ui/signup.dart';
import 'package:kisankonnect/src/ui/splash.dart';

class RouteManager {
  static navigateTo(
    BuildContext context,
    ScreenType screenType, {
    Map<String, Object> args,
  }) {
    Navigator.pushNamed(
      context,
      screenType.name,
      arguments: args,
    );
  }

  static replaceWith(
    BuildContext context,
    ScreenType screenType, {
    Map<String, Object> args,
  }) {
    Navigator.pushReplacementNamed(
      context,
      screenType.name,
      arguments: args,
    );
  }

//This will remove all the previous screens
  static navigateToOnly(
    BuildContext context,
    ScreenType screenType, {
    Map<String, Object> args,
  }) {
    Navigator.pushNamedAndRemoveUntil(
        context, screenType.name, (Route<dynamic> route) => false,
        arguments: args);
  }

  static openNoInternetPage(BuildContext context) {
    navigateTo(context, ScreenType.NO_INTERNET);
  }

  static pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  static Route generateRoute(RouteSettings routeSettings) {
    final screenType =
        getScreenTypeFromName(routeSettings.name) ?? ScreenType.NO_ROUTE;
    switch (screenType) {
      case ScreenType.SPLASH:
        return _buildRoute(routeSettings, Splash());
      case ScreenType.SIGN_IN:
        return _buildRoute(routeSettings, SignIn());
      case ScreenType.SIGN_UP:
        return _buildRoute(routeSettings, SignUp());
      case ScreenType.MOBILE_ENTRY:
        return _buildRoute(routeSettings, MobileEntry());
      case ScreenType.MOBILE_VERIFICATION:
        return _buildRoute(routeSettings, MobileVerification());
      case ScreenType.DASHBOARD:
        return _buildRoute(routeSettings, Dashboard());
      case ScreenType.NO_INTERNET:
        return _buildRoute(routeSettings, NoInternetPage(), noAnimation: true);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${routeSettings.name}')),
          ),
        );
    }
  }

  static MaterialPageRoute _buildRoute(
    RouteSettings settings,
    Widget screen, {
    bool noAnimation: false,
  }) {
    if (noAnimation) {
      return _NoAnimationMaterialPageRoute(
        settings: settings,
        builder: (_) => screen,
      );
    }
    return new MaterialPageRoute(
      settings: settings,
      builder: (_) => screen,
    );
  }
}

enum ScreenType {
  SPLASH,
  SIGN_IN,
  SIGN_UP,
  MOBILE_ENTRY,
  MOBILE_VERIFICATION,
  DASHBOARD,
  NO_INTERNET,
  NO_ROUTE,
}

extension ScreenTypeExtension on ScreenType {
  String get name => this.toString().split('.').last;
}

ScreenType getScreenTypeFromName(String name) {
  return ScreenType.values.firstWhere((e) => e.name == name);
}

class _NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  _NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
