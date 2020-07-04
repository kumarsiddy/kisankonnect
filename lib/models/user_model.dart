import 'package:kisankonnect/models/base_model.dart';
import 'package:kisankonnect/utils/routes.dart';

class UserStatus implements BaseModel, ServerError {
  @override
  String message;

  @override
  bool isSuccess;

  String _name;
  String _email;
  String _mobile;
  bool _isMobileVerified;
  bool _isEmailVerified;
  ScreenType _screenTypeToOpen;

  String get name => _name;

  String get email => _email;

  String get mobile => _mobile;

  bool get isMobileVerified => _isMobileVerified;

  bool get isEmailVerified => _isEmailVerified;

  ScreenType get screenTypeToOpen => _screenTypeToOpen;

  @override
  fromJson(Map<String, dynamic> parsedJson, bool isSuccess) {
    this._name = parsedJson['name'];
    this._email = parsedJson['email'];
    this._mobile = parsedJson['mobile'];
    this._isMobileVerified = parsedJson['isMobileVerified'];
    this._isEmailVerified = parsedJson['isEmailVerified'];
    this.message = parsedJson['message'];
    this._screenTypeToOpen =
        getScreenTypeFromName(parsedJson['screenTypeToOpen']);
    this.isSuccess = isSuccess;
    return this;
  }

  toMap() {
    return {
      'name': _name,
      'email': _email,
      'mobile': _mobile,
      'isMobileVerified': _isMobileVerified,
      'isEmailVerified': _isEmailVerified,
    };
  }
}
