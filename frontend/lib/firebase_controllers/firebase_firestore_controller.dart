import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreController implements FirebaseFirestoreInterface {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> addNewUserInformation(String user, String name, String contactNumber) async {
    await _fireStore.collection("user").doc(user).set({
      "name": name,
      "contact_number": contactNumber,
    });
  }
}
