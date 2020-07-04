import 'package:kisankonnect/models/signup_models.dart';
import 'package:kisankonnect/repos/api_provider.dart';
import 'package:kisankonnect/repos/url_path.dart';

class SignUpApiProvider {
  Future<SignUpResponse> signup( signUpBody) async {
    SignUpResponse signUpResponse = await ApiProvider.post<SignUpResponse>(
      UrlPath.SIGN_UP_URL,
      body: signUpBody.toMap(),
    );
    return signUpResponse;
  }
}
