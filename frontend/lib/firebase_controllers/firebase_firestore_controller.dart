import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/gps_controllers/geocoding_controller.dart';
import 'package:drp_basket_app/locator.dart';
import '../user_type.dart';

class FirebaseFirestoreController implements FirebaseFirestoreInterface {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> addNewUserInformation(
      UserType userType, String user, String name, String contactNumber,
      {String location = ""}) async {
    if (userType == UserType.RECEIVER) {
      await _fireStore.collection(cloudCollection[userType]!).doc(user).set({
        NAME: name,
        CONTACT_NUMBER: contactNumber,
      });
    } else {
      Map<String, double> results =
          await locator<GeoCodingController>().getLatitudeLongitude(location);

      await _fireStore.collection(cloudCollection[userType]!).doc(user).set({
        NAME: name,
        CONTACT_NUMBER: contactNumber,
        LATITUDE: results[LATITUDE]!,
        LONGITUDE: results[LONGITUDE]!,
        ADDRESS: location,
      });
    }
  }

  Stream<Object> getDonors() {
    return _fireStore.collection(DONORS).snapshots();
  }

  Future<List<Map<String, dynamic>>> getOrderAgainList(String uid) async {
    DocumentSnapshot ds = await _fireStore.collection(RECEIVERS).doc(uid).get();
    List<dynamic>? orderAgainList =
        ((ds.data() as Map<String, dynamic>)[ORDER_AGAIN_LIST]);

    List<Map<String, dynamic>> donorInformation = [];
    if (orderAgainList != null) {
      orderAgainList = orderAgainList.map((e) => e as String).toList();
      for (var donorID in orderAgainList) {
        DocumentSnapshot tempDs =
            await _fireStore.collection(DONORS).doc(donorID).get();
        Map<String, dynamic> donorInfo =
            (tempDs.data() as Map<String, dynamic>);
        donorInfo[ID] = donorID;
        donorInformation.add(donorInfo);
      }
    }

    return donorInformation;
  }

  Future<UserType> getUserType(String uid) async {
    late bool exists;
    try {
      await _fireStore.doc("donors/$uid").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      if (exists) {
        return UserType.DONOR;
      } else {
        return UserType.RECEIVER;
      }
    } catch (exception) {
      return UserType.RECEIVER;
    }
  }
}
