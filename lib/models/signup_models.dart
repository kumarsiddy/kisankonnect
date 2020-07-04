import 'package:kisankonnect/models/base_model.dart';

class SignUpResponse implements JwtToken, ServerError, BaseModel {
  @override
  String message;

  @override
  bool isSuccess;

  @override
  String token;

  @override
  fromJson(Map<String, dynamic> parsedJson, bool isSuccess) {
    token = parsedJson['token'];
    message = parsedJson['message'];
    this.isSuccess = isSuccess;
    return this;
  }
}

class SignUpBody {
  String _name;
  String _email;
  String _mobile;
  String _password;

  set name(String name) {
    this._name = name;
  }

  set email(String email) {
    this._email = email;
  }

  set mobile(String mobile) {
    this._mobile = mobile;
  }

  set password(String password) {
    this._password = password;
  }

  toMap() {
    return {
      'name': this._name,
      'email': this._email,
      'mobile': this._mobile,
      'password': this._password,
    };
  }
}
