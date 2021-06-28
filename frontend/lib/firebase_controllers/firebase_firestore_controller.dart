import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/events/charity_event.dart';
import 'package:drp_basket_app/views/charity/receivers/charity_receiver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../locator.dart';
import '../user_type.dart';

class FirebaseFirestoreController implements FirebaseFirestoreInterface {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> addNewUserInformation(
      UserType userType, User user, String name, String contactNumber,
      {String? address, String? description}) async {
    if (userType == UserType.CHARITY) {
      await _fireStore
          .collection(cloudCollection[userType]!)
          .doc(user.uid)
          .set({
        NAME: name,
        CONTACT_NUMBER: contactNumber,
        EMAIL: user.email,
        DESCRIPTION: description,
      });
    } else {
      await _fireStore
          .collection(cloudCollection[userType]!)
          .doc(user.uid)
          .set({
        NAME: name,
        CONTACT_NUMBER: contactNumber,
        EMAIL: user.email,
        ADDRESS: address,
        DONATION_COUNT: 0,
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

  Future<DocumentSnapshot<Map<String, dynamic>>> charityFromID(String id) {
    return _fireStore.collection("charities").doc(id).get();
  }

  Future<void> assignNewRedeemCode(
      String redeemCode, String uid, String donationID, String donorID) {
    return _fireStore
        .collection(REDEEM)
        .doc(redeemCode)
        .set({"user": uid, "donation_event": donationID, "donor": donorID});
  }

  Stream<Object> getContactList({bool sortByLastClaimed: false}) {
    var curUser = locator<UserController>().curUser()!;
    var receivers = _fireStore
        .collection("charities")
        .doc(curUser.uid)
        .collection("receivers_list");
    if (sortByLastClaimed) {
      return receivers.orderBy('last_claimed').snapshots();
    }
    return receivers.orderBy('name').snapshots();
  }

  Future<List> getContactMap() async {
    var curUser = locator<UserController>().curUser()!;
    QuerySnapshot querySnapshot = await _fireStore
        .collection("charities")
        .doc(curUser.uid)
        .collection("receivers_list")
        .get();

    return querySnapshot.docs;
  }

  Future<void> addContactToPending(
      String donationEventID, List contacts) async {
    var curUser = locator<UserController>().curUser()!;
    List<Map<String, String>> contactData = [];

    for (DocumentSnapshot contactDS in contacts) {
      var contactInfo = (contactDS.data() as Map<String, dynamic>);
      contactData.add({
        "name": contactInfo["name"],
        "contact": contactInfo["contact"],
        "uid": contactDS.id,
      });
    }

    _fireStore
        .collection(CHARITIES)
        .doc(curUser.uid)
        .collection("donation_events")
        .doc(donationEventID)
        .update({
      "pending": contactData,
      "confirmed": [],
    });
  }

  Stream<QuerySnapshot<Object?>>? getDonationList() {
    var curUser = locator<UserController>().curUser()!;
    return _fireStore
        .collection('charities')
        .doc(curUser.uid)
        .collection('donation_events')
        .snapshots();
  }

  Future<void> addDonationEvent(DonationEvent de) {
    var curUser = locator<UserController>().curUser()!;
    return _fireStore
        .collection("charities")
        .doc(curUser.uid)
        .collection("donation_events")
        .add({
          'event_name': de.name,
          'event_location': de.location,
          'event_description': de.description,
          'event_date_time': de.dateTime,
          'pending': [],
          'confirmed': [],
        })
        .then((value) => print('Donation Added'))
        .catchError((err) => print("Failed to add donation: $err"));
  }

  // Currently unused
  Future<void> addContact(String name, String contactNumber) async {
    var curUser = locator<UserController>().curUser()!;
    DocumentSnapshot ds =
        await _fireStore.collection("charities").doc(curUser.uid).get();

    List contactList =
        (ds.data() as Map<String, dynamic>)["contact_list"] as List;

    QuerySnapshot foo = await _fireStore
        .collection("receivers")
        .where('name', isEqualTo: name)
        .where('contact_number', isEqualTo: contactNumber)
        .get();

    String receiverID = foo.docs.single.id;

    contactList.add({
      "Name": name.trim(),
      "Contact": contactNumber.trim(),
      "uid": receiverID
    });

    _fireStore
        .collection("charities")
        .doc(curUser.uid)
        .update({"contact_list": contactList});
  }

  Future<void> addReceiver(Receiver receiver) async {
    var curUser = locator<UserController>().curUser()!;
    return _fireStore
        .collection("charities")
        .doc(curUser.uid)
        .collection("receivers_list")
        .add({
          'name': receiver.name,
          'contact': receiver.contact,
          'location': receiver.location,
          'last_claimed': null,
        })
        .then((value) =>
            print('Receiver Added')) //TODO : implement front end warning
        .catchError((err) => print("Failed to add receiver: $err"));
  }

  DocumentReference<Map<String, dynamic>> getCurrentCharity() {
    var curUser = locator<UserController>().curUser()!;
    return _fireStore.collection('charities').doc(curUser.uid);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getReceiver(
      String uid, String id) {
    return _fireStore
        .collection("charities")
        .doc(uid)
        .collection('receivers_list')
        .doc(id)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDonationEvent(
      String uid, String id) {
    return _fireStore
        .collection("charities")
        .doc(uid)
        .collection('donation_events')
        .doc(id)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> donationsClaimed(
      String uid, String receiverID) {
    return _fireStore
        .collection("charities")
        .doc(uid)
        .collection('receivers_list')
        .doc(receiverID)
        .collection('donations_claimed')
        .orderBy('time_claimed', descending: true)
        .snapshots();
  }

  Stream<Object> getDonationEventSnapshot(String donationEventID) {
    var curUser = locator<UserController>().curUser()!;
    return _fireStore
        .collection("charities")
        .doc(curUser.uid)
        .collection("donation_events")
        .doc(donationEventID)
        .snapshots();
  }

  @override
  CollectionReference getCollection(String collectionName) {
    return _fireStore.collection(collectionName);
  }

  Future<int> getDonationCount(String donorID) async {
    DocumentSnapshot ds =
        await _fireStore.collection("donors").doc(donorID).get();
    int donations =
        ((ds.data() as Map<String, dynamic>)["donation_count"] as int);
    return donations;
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAvailableDonations() {
    return _fireStore
        .collection("available_donations")
        .orderBy('time_created', descending: true)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDonor(String donorID) {
    return _fireStore.collection("donors").doc(donorID).snapshots();
  }

  Future<void> addDonationCount(String donorID, int addCount) async {
    DocumentSnapshot ds =
        await _fireStore.collection('donors').doc(donorID).get();
    int count = (ds.data() as Map)[DONATION_COUNT];
    count += addCount;
    await _fireStore
        .collection('donors')
        .doc(donorID)
        .update({DONATION_COUNT: count});
  }
}
