import 'package:kisankonnect/models/user_model.dart';
import 'package:kisankonnect/repos/user_repo.dart';
import 'package:rxdart/rxdart.dart';

class _SplashBloc {
  final _userRepository = UserRepository();
  var _userStatusFetcher = PublishSubject<UserStatus>();

  Stream<UserStatus> get userStatusStream => _userStatusFetcher.stream;

  getUserStatus() async {
    UserStatus userStatus = await _userRepository.getUserStatus();
    _userStatusFetcher.sink.add(userStatus);
  }

  dispose() {
    _userStatusFetcher.close();
  }
}

final _splashBlocObject = _SplashBloc();

_SplashBloc get splashBloc {
  if (_splashBlocObject._userStatusFetcher.isClosed) {
    _splashBlocObject._userStatusFetcher = PublishSubject<UserStatus>();
  }
  return _splashBlocObject;
}
