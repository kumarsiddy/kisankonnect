import 'package:kisankonnect/models/signin_models.dart';
import 'package:kisankonnect/repos/user_repo.dart';
import 'package:rxdart/rxdart.dart';

class _SigninBloc {
  final _userRepository = UserRepository();
  var _signInFetcher = PublishSubject<SignInResponse>();

  Stream<SignInResponse> get signinStream => _signInFetcher.stream;

  signin(String username, String password) async {
    SignInResponse signInResponse =
        await _userRepository.signin(username, password);
    _signInFetcher.sink.add(signInResponse);
  }

  dispose() {
    _signInFetcher.close();
  }
}

final _signinBlocObject = _SigninBloc();

_SigninBloc get signinBloc {
  if (_signinBlocObject._signInFetcher.isClosed) {
    _signinBlocObject._signInFetcher = PublishSubject<SignInResponse>();
  }
  return _signinBlocObject;
}
