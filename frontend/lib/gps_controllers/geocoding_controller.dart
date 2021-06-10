import 'package:drp_basket_app/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../locator.dart';
import 'geolocator_controller.dart';


class GeoCodingController {
  Future<Map<String, double>> getLatitudeLongitude(String destination) async {
    List<Location> locations = await locationFromAddress(destination);

    return {
      LATITUDE: locations[0].latitude,
      LONGITUDE: locations[0].longitude,
    };
  }

  bool inRange(double lat, double long) {
    Position currPosition = locator<GeoLocatorController>().getPosition();
    double distanceInMeters = Geolocator.distanceBetween(lat, long, currPosition.latitude, currPosition.longitude);
    return distanceInMeters < IN_RANGE_THRESHOLD;
  }

}