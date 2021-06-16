import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import 'donation.dart';

class CharityDonationPage extends StatefulWidget {
  final Donation donation;

  const CharityDonationPage(this.donation, {Key? key})
      : super(key: key);

  @override
  _CharityDonationPageState createState() =>
      _CharityDonationPageState(donation);
}

class _CharityDonationPageState extends State<CharityDonationPage> {
  final Donation donation;

  _CharityDonationPageState(this.donation);

  @override
  Widget build(BuildContext context) {
    var _store = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: _store.collection('donors').doc(donation.donorID).snapshots(),
        builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var donor = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _donorInfo(donor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _donorInfo(Map<String, dynamic> donor) {
    return Column(
      children: [
        Text(
          donor['name'],
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Card(
          child: ListTile(
              leading: Icon(Icons.call), title: Text(donor['contact_number'])),
        ),
        Card(
          child: ListTile(
              leading: Icon(Icons.home), title: Text(donor['address'])),
        ),
      ],
    );
  }
}
