import 'dart:convert';

import 'package:kisankonnect/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static const String _KEY_TOKEN = 'token';
  static const String _USER_STATUS = 'user-status';

  static final LocalCache _singleton = new LocalCache.internal();

  LocalCache.internal();

  static LocalCache getInstance() => _singleton;

  static SharedPreferences _preference;

  Future<SharedPreferences> _getPreferences() async {
    if (_preference == null) {
      _preference = await SharedPreferences.getInstance();
    }
    return _preference;
  }

  void saveToken(String token) async {
    (await _getPreferences()).setString(_KEY_TOKEN, token);
  }

  Future<String> getToken() async {
    return (await _getPreferences()).getString(_KEY_TOKEN);
  }

  void saveUserStatus(UserStatus userStatus) async {
    (await _getPreferences())
        .setString(_USER_STATUS, json.encode(userStatus.toMap()));
  }

  Future<UserStatus> getUserStatus() async {
    final userStatusJson = (await _getPreferences()).getString(_USER_STATUS);
    print(userStatusJson);
    UserStatus userStatus = UserStatus();
    return userStatus.fromJson(json.decode(userStatusJson), true);
  }
}
