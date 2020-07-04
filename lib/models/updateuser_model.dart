import 'package:kisankonnect/models/base_model.dart';
import 'package:kisankonnect/models/gender.dart';

class UpdateUserResponse implements BaseModel, ServerError {
  @override
  String message;

  @override
  bool isSuccess;

  @override
  fromJson(Map<String, dynamic> parsedJson, bool isSuccess) {
    message = parsedJson['message'];
    this.isSuccess = isSuccess;
    return this;
  }
}

class UserDetails {
  String _name;
  Gender _gender;
  String _email;
  String _mobile;
  String _password;

  set name(String name) {
    this._name = name;
  }

  set gender(Gender gender) {
    this._gender = gender;
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
      'gender': this._gender.name,
      'email': this._email,
      'mobile': this._mobile,
      'password': this._password,
    };
  }
}

class UpdateUserBody {
  final UserDetails userDetails;

  UpdateUserBody(this.userDetails);

  toMap() {
    return {
      'userDetails': userDetails.toMap(),
    };
  }
}
