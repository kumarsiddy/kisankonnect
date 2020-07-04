import 'package:geolocator/geolocator.dart';
import 'package:kisankonnect/models/serviceability.model.dart';
import 'package:kisankonnect/repos/location_provider.dart';
import 'package:kisankonnect/repos/user_repo.dart';
import 'package:rxdart/rxdart.dart';

class CheckPincodeBloc {
  final _userRepository = UserRepository();
  var _addressFetcher = PublishSubject<Placemark>();
  var _pincodeServiceableFetcher = PublishSubject<ServiceableResponse>();

  Stream<Placemark> get addressStream => _addressFetcher.stream;

  Stream<ServiceableResponse> get pincodeServiceableStream =>
      _pincodeServiceableFetcher.stream;

  getAddress() async {
    Placemark placemark = await LocationProvider.getCurrentAddress();
    _addressFetcher.sink.add(placemark);
  }

  checkServiceability(String pincode) async {
    ServiceableResponse serviceableResponse =
        await _userRepository.isPincodeServiceable(pincode);
    _pincodeServiceableFetcher.sink.add(serviceableResponse);
  }

  dispose() {
    _addressFetcher.close();
    _pincodeServiceableFetcher.close();
  }
}

CheckPincodeBloc _checkPincodeBlocObject = CheckPincodeBloc();

CheckPincodeBloc get checkPincodeBloc {
  if (_checkPincodeBlocObject._addressFetcher.isClosed) {
    _checkPincodeBlocObject._addressFetcher = PublishSubject<Placemark>();
  }
  if (_checkPincodeBlocObject._pincodeServiceableFetcher.isClosed) {
    _checkPincodeBlocObject._pincodeServiceableFetcher =
        PublishSubject<ServiceableResponse>();
  }
  return _checkPincodeBlocObject;
}
