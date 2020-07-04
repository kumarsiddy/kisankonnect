import 'package:kisankonnect/models/otp_models.dart';
import 'package:kisankonnect/repos/api_provider.dart';
import 'package:kisankonnect/repos/url_path.dart';

class OtpApiProvider {
  Future<OtpResponse> makeCall(
      OtpStatus otpStatus, OtpRequestBody otpRequestBody) async {
    OtpResponse otpResponse = await ApiProvider.getWithToken<OtpResponse>(
      _getOtpUrl(otpStatus),
      params: otpRequestBody.toMap(),
    );
    return otpResponse..setOtpStatus(otpStatus);
  }

  String _getOtpUrl(OtpStatus otpStatus) {
    switch (otpStatus) {
      case OtpStatus.GET:
        return UrlPath.GET_OTP_URL;
      case OtpStatus.VALIDATE:
        return UrlPath.VALIDATE_OTP_URL;
      case OtpStatus.RESEND:
        return UrlPath.RESEND_OTP_URL;
    }
    throw new Exception('OtpStatus not found.');
  }
}
