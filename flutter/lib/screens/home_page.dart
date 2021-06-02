import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/screens/donor/donor_home_page.dart';
import 'package:drp_basket_app/screens/receivers/receiver_home_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String id = "HomePage";
  final _fireStore = FirebaseFirestore.instance;

  HomePage({Key? key}): super(key: key);

  Future<void> getName() async {
    DocumentSnapshot ds =
        await _fireStore.collection("testing").doc("testing").get();
    String name = (ds.data() as Map<String, dynamic>)["testing"];
    print(name);
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
          LongButton(
            text: "Receiver",
            onPressed: () => {Navigator.pushNamed(context, ReceiverHomePage.id)},
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
