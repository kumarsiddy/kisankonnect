import 'package:kisankonnect/models/gender.dart';
import 'package:kisankonnect/models/signup_models.dart';
import 'package:kisankonnect/models/updateuser_model.dart';
import 'package:kisankonnect/repos/user_repo.dart';
import 'package:rxdart/rxdart.dart';

class _SignUpBloc {
  final _userRepository = UserRepository();
  var _signupFetcher = PublishSubject<SignUpResponse>();

  Stream<SignUpResponse> get signupStream => _signupFetcher.stream;

  singUp({
    String name,
    Gender gender,
    String email,
    String mobile,
    String password,
  }) async {
    UserDetails signUpBody = UserDetails();
    signUpBody.name = name;
    signUpBody.gender = gender;
    signUpBody.email = email;
    signUpBody.mobile = mobile;
    signUpBody.password = password;

    SignUpResponse signUpResponse = await _userRepository.signup(signUpBody);
    _signupFetcher.sink.add(signUpResponse);
  }

  dispose() {
    _signupFetcher.close();
  }
}

final _signupBlocObject = _SignUpBloc();

_SignUpBloc get signupBloc {
  if (_signupBlocObject._signupFetcher.isClosed) {
    _signupBlocObject._signupFetcher = PublishSubject<SignUpResponse>();
  }
  return _signupBlocObject;
}
