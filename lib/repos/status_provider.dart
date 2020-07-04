import 'package:kisankonnect/models/user_model.dart';
import 'package:kisankonnect/repos/api_provider.dart';
import 'package:kisankonnect/repos/url_path.dart';

class StatusProvider {
  Future<UserStatus> getUserStatus() async {
    UserStatus userStatus =
        await ApiProvider.getWithToken<UserStatus>(UrlPath.GET_USER_STATUS);
    return userStatus;
  }
}
