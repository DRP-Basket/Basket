import 'package:geolocator/geolocator.dart';


class GeoLocatorController {
  late bool _serviceEnabled;
  late LocationPermission _permission;
  late Position _currentPosition;

  GeoLocatorController() {
    determinePosition();
  }

  Future<void> enableLocationService() async {
    // Test if location services are enabled.
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<Position> determinePosition() async {
    await enableLocationService();

    _currentPosition = await Geolocator.getCurrentPosition();

    Geolocator.getPositionStream().listen((Position position) {
      _currentPosition = position;
    });

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return _currentPosition;
  }

  Position getPosition() {
    return _currentPosition;
  }
}
