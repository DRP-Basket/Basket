import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';

class CharityDonationPage extends StatefulWidget {
  final String donorID;
  final String donationID;

  const CharityDonationPage(this.donorID, this.donationID, {Key? key})
      : super(key: key);

  @override
  _CharityDonationPageState createState() =>
      _CharityDonationPageState(donorID, donationID);
}

class _CharityDonationPageState extends State<CharityDonationPage> {
  final String donorID;
  final String donationID;

  _CharityDonationPageState(this.donorID, this.donationID);

  @override
  Widget build(BuildContext context) {
    var store = FirebaseFirestore.instance;
    var donorDoc = store.collection('donors').doc(donorID);

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: donorDoc.snapshots(),
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
