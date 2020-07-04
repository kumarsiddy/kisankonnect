import 'base_model.dart';

class SignInResponse implements JwtToken, ServerError, BaseModel {
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

class SignInBody {
  String _username;
  String _password;

  SignInBody(this._username, this._password);

  toMap() {
    return {
      'username': this._username,
      'password': this._password,
    };
  }
}
