import 'package:kisankonnect/models/signin_models.dart';
import 'package:kisankonnect/repos/api_provider.dart';
import 'package:kisankonnect/repos/url_path.dart';

class SignInApiProvider {
  Future<SignInResponse> singin(String username, String password) async {
    SignInResponse signInResponse = await ApiProvider.post<SignInResponse>(
      UrlPath.SIGN_IN_URL,
      body: SignInBody(username, password).toMap(),
    );
    return signInResponse;
  }
}
