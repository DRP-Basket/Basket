import 'package:drp_basket_app/views/charity/events/charity_event.dart';
import 'package:drp_basket_app/views/charity/receivers/charity_receiver.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user_type.dart';

class FirebaseFirestoreInterface {
  Future<void> addNewUserInformation(
      UserType userType, User user, String name, String contactNumber,
      {String? address, String? description}) async {}

  getDonors() {}

  getUserType(String uid) async {}

  getOrderAgainList(String uid) async {}

  donorFromID(String id) {}

  charityFromID(String id) {}

  assignNewRedeemCode(String redeemCode, String uid, String donationID) {}

  getContactList(String uid, {bool sortByLastClaimed: false}) {}

  getContactMap(String uid) {}

  getDonationList(String uid) {}

  addContact(String uid, String name, String contactNumber) {}

  addDonationEvent(String uid, DonationEvent de) {}

  addReceiver(String uid, Receiver receiverToAdd) {}

  getReceiver(String uid, String id) {}

  getDonationEvent(String uid, String id) {}

  getDonationEventSnapshot(String uid, String donationEventID) {}

  addContactToPending(String uid, String donationEventID, List contacts) {}

  donationsClaimed(String uid, String receiverID) {}

  getCollection(String collectionName) {}

  getDonationCount(String donorID) {}

  getAvailableDonations() {}

  getDonor(String donorID) {}

  addDonationCount(String donorID, int addCount) {}
}
