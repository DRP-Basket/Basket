import 'package:drp_basket_app/views/charity/donation_event.dart';
import 'package:drp_basket_app/views/charity/receiver.dart';

import '../user_type.dart';

class FirebaseFirestoreInterface {
  Future<void> addNewUserInformation(
      UserType userType, String user, String name, String contactNumber,
      {String location = ""}) async {}

  getDonors() {}

  getUserType(String uid) async {}

  getOrderAgainList(String uid) async {}

  donorFromID(String id) {}

  assignNewRedeemCode(String redeemCode, String uid, String donationID) {}

  getContactList({bool sortByLastClaimed: false}) {}

  getContactMap() {}

  getDonationList() {}

  addDonation(String title, String location, String date) {}

  addContact(String name, String contactNumber) {}

  addDonationEvent(DonationEvent de) {}

  addReceiver(Receiver receiverToAdd) {}

  getReceiver(String id) {}

  getDonationEvent(String id) {}

  getDonationEventSnapshot(String donationEventID) {}

  addContactToPending(String donationEventID, List contacts) {}

  donationsClaimed(String receiverID) {}
  getCollection(String collectionName) {}

  getDonation() {}
}
