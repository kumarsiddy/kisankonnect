import 'package:kisankonnect/models/otp_models.dart';
import 'package:kisankonnect/models/serviceability.model.dart';
import 'package:kisankonnect/models/signin_models.dart';
import 'package:kisankonnect/models/signup_models.dart';
import 'package:kisankonnect/models/updateuser_model.dart';
import 'package:kisankonnect/models/user_model.dart';

abstract class BaseModel {
  static final _constructors = {
    SignInResponse: () => SignInResponse(),
    SignUpResponse: () => SignUpResponse(),
    OtpResponse: () => OtpResponse(),
    UserStatus: () => UserStatus(),
    UpdateUserResponse: () => UpdateUserResponse(),
    ServiceableResponse: () => ServiceableResponse(),
  };

  static BaseModel create(Type type) {
    return _constructors[type]();
  }

  bool _isSuccess;

  BaseModel fromJson(Map<String, dynamic> parsedJson, bool isSuccess);

  set isSuccess(bool isSuccess) {
    this._isSuccess = isSuccess;
  }

  bool get isSuccess => _isSuccess;
}

abstract class JwtToken {
  String _token;

  set token(String token) {
    this._token = token;
  }

  String get token => _token;
}

abstract class ServerError {
  String _message;

  set message(String message) {
    this._message = message;
  }

  String get message => _message;
}
