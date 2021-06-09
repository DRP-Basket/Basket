import '../user_type.dart';

class FirebaseFirestoreInterface {
  Future<void> addNewUserInformation(
      UserType userType, String user, String name, String contactNumber,
      {String location = ""}) async {}

  getDonors () {}

  getUserType(String uid) async {}

  getOrderAgainList(String uid) async {}
}
