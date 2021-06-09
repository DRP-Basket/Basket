import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/components/donor_thumbnail.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/gps_controllers/geocoding_controller.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';

import '../constants.dart';
import '../locator.dart';

class ReceiverController {
  FirebaseStorageInterface _firebaseStorageController = locator<
      FirebaseStorageInterface>();
  FirebaseFirestoreInterface _firebaseFirestoreController =
  locator<FirebaseFirestoreInterface>();

  Stream<Object> getDonorStream() {
    return _firebaseFirestoreController.getDonors();
  }

  Future<List<DonorThumbnail>> getOrderAgainList() async {
    List<Map<String, dynamic>> orderAgainList = await locator<UserController>().getUserOrderAgainList();
    List<DonorThumbnail> donorThumbnails = [];

    for (var donor in orderAgainList) {
      Future<String> url = _firebaseStorageController.getImageUrl(UserType.DONOR, donor[ID]);
      donorThumbnails.add(DonorThumbnail(
          donorName: donor[NAME],
          donorURL: url,
          donorAddress: donor[ADDRESS]));
    }

    return donorThumbnails;
  }

  List<DonorThumbnail> generateThumbnail(var snapshot) {
    List<DonorThumbnail> donorThumbnails = [];
    final donors = (snapshot.data as QuerySnapshot).docs.reversed;
    for (var donor in donors) {
      double latitude = donor.get(LATITUDE);
      double longitude = donor.get(LONGITUDE);

      if (locator<GeoCodingController>().inRange(latitude, longitude)) {
        Future<String> url = _firebaseStorageController.getImageUrl(UserType.DONOR, donor.id);
        donorThumbnails.add(DonorThumbnail(
            donorName: donor.get(NAME),
            donorURL: url,
            donorAddress: donor.get(ADDRESS)));
      }
    }
    return donorThumbnails;
  }


}
