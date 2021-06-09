import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';

class FirebaseFirestoreController implements FirebaseFirestoreInterface {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> addNewUserInformation(
      String user, String name, String contactNumber) async {
    await _fireStore.collection("user").doc(user).set({
      "name": name,
      "contact_number": contactNumber,
    });
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> donorFromID(String id) {
    return _fireStore.collection('user').doc(id).get();
  }

}
