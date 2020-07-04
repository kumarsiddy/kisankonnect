import 'package:kisankonnect/models/base_model.dart';

class OtpResponse implements BaseModel, ServerError {
  @override
  String message;

  OtpStatus otpStatus;

  @override
  bool isSuccess;

  String type;

  @override
  fromJson(Map<String, dynamic> parsedJson, bool isSuccess) {
    this.isSuccess = isSuccess;
    this.type = parsedJson['type'];
    this.message = parsedJson['message'];
    return this;
  }

  setOtpStatus(OtpStatus otpStatus) {
    this.otpStatus = otpStatus;
  }
}

class OtpRequestBody {
  String mobile;
  String otp;

  OtpRequestBody(String mobile) {
    this.mobile = mobile;
  }

  OtpRequestBody.fromOtp(String mobile, String otp) {
    this.mobile = mobile;
    this.otp = otp;
  }

  toMap() => {
        'mobile': this.mobile,
        'otp': this.otp,
      };
}

enum OtpStatus {
  GET,
  VALIDATE,
  RESEND,
}
