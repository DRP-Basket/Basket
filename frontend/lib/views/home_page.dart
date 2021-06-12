import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donor/donor_home_page.dart';
import 'package:flutter/material.dart';

import 'charity/charity_donation_page.dart';

class HomePage extends StatelessWidget {
  static const String id = "HomePage";

  HomePage({Key? key}) : super(key: key);

  Future<void> getName() async {
    DocumentSnapshot ds = await locator<FirebaseFirestoreInterface>()
        .getCollection("testing")
        .doc("testing")
        .get();
    String name = (ds.data() as Map<String, dynamic>)["testing"];
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
              locator<UserController>().testLogInWithEmailAndPassword();
              Navigator.pushNamed(context, DonorHomePage.id);
            },
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
          ),
          // LongButton(
          //   text: "Receiver",
          //   onPressed: () => {Navigator.pushNamed(context, ReceiverHomeScreen.id)},
          //   backgroundColor: Colors.greenAccent,
          //   textColor: Colors.white,
          // ),
          LongButton(
            text: "Charity",
            onPressed: () =>
                {Navigator.pushNamed(context, CharityDonationPage.id)},
            backgroundColor: Colors.purpleAccent,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
