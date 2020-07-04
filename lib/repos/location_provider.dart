import 'package:geolocator/geolocator.dart';

class LocationProvider {
  static getLocationPosition() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static getCurrentAddress() async {
    Position position = await getLocationPosition();
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    return placemark[0];
  }
}
