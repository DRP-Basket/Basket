import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/views/charity/utilities/utilities.dart';
import 'package:drp_basket_app/views/donor/donations/donor_donation_form.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import 'claim_request_form.dart';

class CharityDonationPage extends StatefulWidget {
  final Donation donation;

  const CharityDonationPage(this.donation, {Key? key}) : super(key: key);

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
          if (!snapshot.hasData) {
            return Utilities.loading();
          }
          var donor = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _donorInfo(donor),
                  _donationInfo(),
                  SizedBox(
                    height: 20,
                  ),
                  _pingDonorButton(donation),
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

  Widget _donationInfo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Donation Info'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.watch_later_sharp),
            title: Text('Collect By'),
            subtitle: Text(formatDateTime(donation.collectBy)),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description_sharp),
            title: Text('Description'),
            subtitle: Text(donation.description == null
                ? '(empty)'
                : donation.description!),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Time Posted'),
            subtitle: Text(formatDateTime(donation.timeCreated)),
          ),
        ],
      ),
    );
  }

  Widget _pingDonorButton(Donation donation) {
    return ElevatedButton.icon(
      icon: Icon(Icons.send_sharp),
      label: Text('Request Claim'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10),
        primary: primary_color,
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClaimRequestForm(donation)));
      },
    );
  }
}
