import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import '../user_type.dart';

class FirebaseFirestoreController implements FirebaseFirestoreInterface {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> addNewUserInformation(UserType userType, String user, String name, String contactNumber) async {
    await _fireStore.collection(cloudCollection[userType]!).doc(user).set({
      "name": name,
      "contact_number": contactNumber,
    });
  }
}
