import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kisankonnect/src/customview/snackbar.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:kisankonnect/utils/network_manager.dart';

class NoInternetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoInternetPageState();
  }
}

class _NoInternetPageState extends State<NoInternetPage> {
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = NetworkManager.getInstance()
        .connectionChangeStream
        .listen((isConnected) {
      if (isConnected) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColor.SNOW_WHITE.color,
        body: Builder(
          builder: (context) => _getNoInternetPage(context),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  _getNoInternetPage(BuildContext context) {
    _onRetry() {
      NetworkManager.getInstance().checkConnection().then((isConnected) {
        if (isConnected) {
          Navigator.pop(context);
        } else {
          CustomSnackbar.showError(context, AppString.connect_to_internet);
        }
      });
    }

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('graphics/no_internet.png'),
          ),
          SizedBox(height: 72),
          TitleText(AppString.internet_error),
          SizedBox(height: 4),
          SubTitleText(AppString.internet_not_connected),
          SizedBox(height: 64),
          CustomButton(
            AppString.retry,
            _onRetry,
          ),
        ],
      ),
    );
  }
}
