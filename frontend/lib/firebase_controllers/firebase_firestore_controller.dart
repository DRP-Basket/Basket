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
    if (userType == UserType.CHARITY) {
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
      await _fireStore.doc("$DONORS/$uid").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      if (exists) {
        return UserType.DONOR;
      } else {
        return UserType.CHARITY;
      }
    } catch (exception) {
      return UserType.CHARITY;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> donorFromID(String id) {
    return _fireStore.collection('user').doc(id).get();
  }

  Future<void> assignNewRedeemCode(
      String redeemCode, String uid, String donationID) {
    return _fireStore
        .collection(REDEEM)
        .doc(redeemCode)
        .set({"user": uid, "donation_event": donationID});
  }

  Stream<Object> getContactList() {
    return _fireStore.collection("charities").doc("ex-charity").snapshots();
  }

  Future<List> getContactMap() async {
    DocumentSnapshot ds =
        await _fireStore.collection(CHARITIES).doc("ex-charity").get();
    return ((ds.data() as Map<String, dynamic>)[CONTACT_LIST] as List);
  }

  Stream<QuerySnapshot<Object?>> getDonationList() {
    return _fireStore
        .collection('charities')
        .doc('ex-charity')
        .collection('donations')
        .snapshots();
  }

  Future<void> addDonation(String title, String location, String date) async {
    CollectionReference donations = _fireStore
        .collection("charities")
        .doc("ex-charity")
        .collection("donations");
    return donations
        .add({
          'title': title,
          'location': location,
          'date': date,
        })
        .then((value) => print('Donation Added'))
        .catchError((err) => print("Failed to add donation: $err"));
  }

  Future<void> addContact(String name, String contactNumber) async {
    DocumentSnapshot ds =
        await _fireStore.collection("charities").doc("ex-charity").get();

    List contactList =
        (ds.data() as Map<String, dynamic>)["contact_list"] as List;

    QuerySnapshot foo = await _fireStore
        .collection("receivers")
        .where('name', isEqualTo: name)
        .where('contact_number', isEqualTo: contactNumber)
        .get();

    String uid = foo.docs.single.id;

    contactList.add(
        {"Name": name.trim(), "Contact": contactNumber.trim(), "uid": uid});

    _fireStore
        .collection("charities")
        .doc("ex-charity")
        .update({"contact_list": contactList});
  }

  @override
  CollectionReference getCollection(String collectionName) {
    return _fireStore.collection(collectionName);
  }
}
