import 'package:kisankonnect/models/otp_models.dart';
import 'package:kisankonnect/repos/user_repo.dart';
import 'package:rxdart/rxdart.dart';

class _OtpBloc {
  final _userRepository = UserRepository();
  var _otpFetcher = PublishSubject<OtpResponse>();

  Stream<OtpResponse> get otpStream => _otpFetcher.stream;

  getOtp(String mobile) async {
    OtpResponse otpResponse =
        await _userRepository.getOtp(OtpRequestBody(mobile));
    _otpFetcher.sink.add(otpResponse);
  }

  void resendOtp(String mobile) async {
    OtpResponse otpResponse =
        await _userRepository.resendOtp(OtpRequestBody(mobile));
    _otpFetcher.sink.add(otpResponse);
  }

  void validateOtp(String mobile, String otp) async {
    OtpResponse otpResponse =
        await _userRepository.validateOtp(OtpRequestBody.fromOtp(mobile, otp));
    _otpFetcher.sink.add(otpResponse);
  }

  dispose() {
    _otpFetcher.close();
  }
}

final _otpBlocObject = _OtpBloc();

_OtpBloc get otpBloc {
  if (_otpBlocObject._otpFetcher.isClosed) {
    _otpBlocObject._otpFetcher = PublishSubject<OtpResponse>();
  }
  return _otpBlocObject;
}
