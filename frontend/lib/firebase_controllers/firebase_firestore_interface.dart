import 'package:drp_basket_app/views/charity/events/charity_event.dart';
import 'package:drp_basket_app/views/charity/contacts/charity_receiver.dart';
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

  getContactList({bool sortByLastClaimed: false}) {}

  getContactMap() {}

  getDonationList() {}

  addContact(String name, String contactNumber) {}

  addDonationEvent(DonationEvent de) {}

  addReceiver(Receiver receiverToAdd) {}

  getReceiver(String id) {}

  getDonationEvent(String id) {}

  getDonationEventSnapshot(String donationEventID) {}

  addContactToPending(String donationEventID, List contacts) {}

  donationsClaimed(String receiverID) {}
  getCollection(String collectionName) {}

  getDonationCount(String donorID) {}

  getAvailableDonations() {}

  getDonor(String donorID) {}

  addDonationCount(String donorID, int addCount) {}
}
