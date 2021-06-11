import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/views/donor/donor_home_page.dart';
import 'package:drp_basket_app/views/receivers/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'charity/charity_donation_page.dart';

class HomePage extends StatelessWidget {
  static const String id = "HomePage";
  final _fireStore = FirebaseFirestore.instance;

  HomePage({Key? key}): super(key: key);

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
            onPressed: () => {Navigator.pushNamed(context, DonorHomePage.id)},
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
            onPressed: () => {Navigator.pushNamed(context, CharityDonationPage.id)},
            backgroundColor: Colors.purpleAccent,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
