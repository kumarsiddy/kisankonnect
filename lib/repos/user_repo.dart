import 'package:kisankonnect/models/otp_models.dart';
import 'package:kisankonnect/models/serviceability.model.dart';
import 'package:kisankonnect/models/signin_models.dart';
import 'package:kisankonnect/models/signup_models.dart';
import 'package:kisankonnect/models/updateuser_model.dart';
import 'package:kisankonnect/models/user_model.dart';
import 'package:kisankonnect/repos/api_provider.dart';
import 'package:kisankonnect/repos/otp_api_provider.dart';
import 'package:kisankonnect/repos/signin_api_provider.dart';
import 'package:kisankonnect/repos/signup_api_provider.dart';
import 'package:kisankonnect/repos/status_provider.dart';
import 'package:kisankonnect/repos/updateuser_api_provider.dart';
import 'package:kisankonnect/repos/url_path.dart';

class UserRepository {
  final _signInApiProvider = SignInApiProvider();
  final _signUpApiProvider = SignUpApiProvider();
  final _otpApiProvider = OtpApiProvider();
  final _statusProvider = StatusProvider();
  final _updateUserApiProvider = UpdateUserApiProvider();

  Future<SignInResponse> signin(String username, String password) =>
      _signInApiProvider.singin(username, password);

  Future<SignUpResponse> signup(UserDetails signUpBody) =>
      _signUpApiProvider.signup(signUpBody);

  Future<OtpResponse> getOtp(OtpRequestBody otpRequestBody) =>
      _otpApiProvider.makeCall(OtpStatus.GET, otpRequestBody);

  Future<OtpResponse> resendOtp(OtpRequestBody otpRequestBody) =>
      _otpApiProvider.makeCall(OtpStatus.RESEND, otpRequestBody);

  Future<OtpResponse> validateOtp(OtpRequestBody otpRequestBody) =>
      _otpApiProvider.makeCall(OtpStatus.VALIDATE, otpRequestBody);

  Future<UserStatus> getUserStatus() => _statusProvider.getUserStatus();

  Future<UpdateUserResponse> updateUserDetails(UpdateUserBody updateUserBody) =>
      _updateUserApiProvider.updateUser(updateUserBody);

  Future<ServiceableResponse> isPincodeServiceable(String pincode) async {
    return await ApiProvider.get<ServiceableResponse>(
      UrlPath.GET_IS_PINCODE_SERVICEABLE,
      params: ServiceableBody(pincode).toMap(),
    );
  }
}
