import 'package:kisankonnect/models/updateuser_model.dart';
import 'package:kisankonnect/repos/api_provider.dart';
import 'package:kisankonnect/repos/url_path.dart';

class UpdateUserApiProvider {
  Future<UpdateUserResponse> updateUser(UpdateUserBody updateUserBody) async {
    UpdateUserResponse updateUserResponse =
        await ApiProvider.postWithToken<UpdateUserResponse>(UrlPath.UPDATE_USER,
            body: updateUserBody.toMap());
    return updateUserResponse;
  }
}
