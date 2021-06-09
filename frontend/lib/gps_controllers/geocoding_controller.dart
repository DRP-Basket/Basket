import 'package:drp_basket_app/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class GeoCodingController {
  Future<Map<String, double>> getLatitudeLongitude(String destination) async {
    List<Location> locations = await locationFromAddress(destination);

    return {
      LATITUDE: locations[0].latitude,
      LONGITUDE: locations[0].longitude,
    };
  }

  bool inRange(double firstLat, double firstLong, double secondLat, double secondLong) {
    double distanceInMeters = Geolocator.distanceBetween(firstLat, firstLong, secondLat, secondLong);
    return distanceInMeters < IN_RANGE_THRESHOLD;
  }

}