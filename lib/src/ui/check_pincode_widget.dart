import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kisankonnect/blocs/check_pincode_bloc.dart';
import 'package:kisankonnect/models/permission.dart';
import 'package:kisankonnect/models/serviceability.model.dart';
import 'package:kisankonnect/src/customview/snackbar.dart';
import 'package:kisankonnect/src/customview/view.dart';
import 'package:kisankonnect/src/resources/platform_bridge.dart';
import 'package:kisankonnect/src/resources/resources.dart';
import 'package:kisankonnect/utils/logger.dart';
import 'package:kisankonnect/utils/routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CheckPincode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckPincodeState();
  }
}

class _CheckPincodeState extends State<CheckPincode> {
  String pincode;
  bool isLoading = false;
  final TextEditingController pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PlatformBridge.getLocationPermission(context).then(
      (Permission permission) {
        if (permission.isGranted) {
          getAddressFromLocation();
        }
      },
    );
    initPincodeServiceabilityListener();
    initAddressFromLocationListener();
  }

  getAddressFromLocation() {
    setIsLoading(true);
    checkPincodeBloc.getAddress();
  }

  initPincodeServiceabilityListener() {
    checkPincodeBloc.pincodeServiceableStream
        .listen((ServiceableResponse serviceableResponse) {
      setIsLoading(false);
      if (serviceableResponse != null &&
          serviceableResponse.isPincodeServiceable) {
        RouteManager.replaceWith(context, ScreenType.SIGN_UP);
      } else {
        CustomSnackbar.showError(context, serviceableResponse.message);
      }
    }).onError((_) => setIsLoading(false));
  }

  initAddressFromLocationListener() {
    checkPincodeBloc.addressStream.listen((Placemark placemark) {
      setIsLoading(false);
      Logger.d(placemark.toJson().toString());
      Logger.d(placemark.postalCode);
      setState(() {
        pincode = placemark.postalCode;
        pincodeController.text = pincode;
      });
    }).onError((_) => setIsLoading(false));
  }

  setIsLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  onCheckServiceability() {
    if (pincode?.length == 6) {
      checkPincodeBloc.checkServiceability(pincode);
    } else {
      CustomSnackbar.showError(context, AppString.invalid_pincode);
    }
  }

  void dispose() {
    super.dispose();
    checkPincodeBloc.dispose();
  }

  initServiceabilityListListener() {
    checkPincodeBloc.pincodeServiceableStream
        .listen((ServiceableResponse serviceableResponse) {
      if (serviceableResponse != null &&
          serviceableResponse.isPincodeServiceable) {
      } else {
        CustomSnackbar.showError(context, serviceableResponse.message);
      }
    }).onError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AbsorbPointer(
        absorbing: isLoading,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                TitleText(AppString.enter_pincode_for_serviceability),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: PinCodeTextField(
                    length: 6,
                    obsecureText: false,
                    controller: pincodeController,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    onChanged: (pincode) {
                      setState(() {
                        this.pincode = pincode;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                CustomButton(
                  AppString.check_serviceability,
                  pincode != null ? onCheckServiceability : null,
                ),
                SizedBox(height: 16),
                Visibility(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      backgroundColor: AppColor.PRIMARY.color,
                    ),
                  ),
                  visible: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
