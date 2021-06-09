import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/gps_controllers/geocoding_controller.dart';
import 'package:drp_basket_app/locator.dart';
import '../user_type.dart';

class FirebaseFirestoreController implements FirebaseFirestoreInterface {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> addNewUserInformation(UserType userType, String user,
      String name, String contactNumber, {String location = ""}) async {

    if (userType == UserType.RECEIVER) {
      await _fireStore.collection(cloudCollection[userType]!).doc(user).set({
        "name": name,
        "contact_number": contactNumber,
      });
    } else {
      Map<String, double> results = await locator<GeoCodingController>()
          .getLatitudeLongitude(location);

      await _fireStore.collection(cloudCollection[userType]!).doc(user).set({
        "name": name,
        "contact_number": contactNumber,
        LATITUDE: results[LATITUDE]!,
        LONGITUDE: results[LONGITUDE]!,
        ADDRESS: location,
      });
    }
  }
}
