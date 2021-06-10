import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_auth_controller.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donor/donor_home_page.dart';
import 'package:drp_basket_app/views/receivers/receiver_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String id = "HomePage";
  final _fireStore = FirebaseFirestore.instance;
  FirebaseAuthController _firebaseAuthController = FirebaseAuthController();

  HomePage({Key? key}) : super(key: key);

  Future<void> getName() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    DocumentSnapshot ds =
        await _fireStore.collection("testing").doc("testing").get();
    String name = (ds.data() as Map<String, dynamic>)["testing"];
    print(name);
    // final user = _firebaseAuth.currentUser;
    // if (user != null) {
    //   print(user.email);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LongButton(
            text: "Test Firebase Connection",
            onPressed: getName,
            backgroundColor: Colors.pinkAccent,
            textColor: Colors.white,
          ),
          LongButton(
            text: "Donor",
            onPressed: () async {
              await _firebaseAuthController.loginWithEmailAndPassword(
                  "donor@basket.com", "basket123");
              Navigator.pushNamed(context, DonorHomePage.id);
            },
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
          ),
          LongButton(
            text: "Receiver",
            onPressed: () =>
                {Navigator.pushNamed(context, ReceiverHomePage.id)},
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
