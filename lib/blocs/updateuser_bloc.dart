import 'package:kisankonnect/models/updateuser_model.dart';
import 'package:kisankonnect/repos/user_repo.dart';
import 'package:rxdart/rxdart.dart';

class _UpdateUserBloc {
  final UserRepository _userRepository = UserRepository();
  var _saveMobileFetcher = PublishSubject<UpdateUserResponse>();

  Stream<UpdateUserResponse> get saveMobileStream => _saveMobileFetcher.stream;

  saveMobile(String mobile) async {
    UserDetails userDetails = UserDetails();
    userDetails.mobile = mobile;

    UpdateUserResponse updateUserResponse =
        await _userRepository.updateUserDetails(UpdateUserBody(userDetails));
    _saveMobileFetcher.sink.add(updateUserResponse);
  }

  saveUserDetails(UpdateUserBody updateUserBody) {}

  dispose() {
    _saveMobileFetcher.close();
  }
}

final _updateUserBlocObject = _UpdateUserBloc();

_UpdateUserBloc get updateUserBloc {
  if (_updateUserBlocObject._saveMobileFetcher.isClosed) {
    _updateUserBlocObject._saveMobileFetcher =
        PublishSubject<UpdateUserResponse>();
  }
  return _updateUserBlocObject;
}
