import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/charity/utilities/utilities.dart';
import 'package:drp_basket_app/views/donor/donations/donor_donation_form.dart';
import 'package:drp_basket_app/views/donor/rank.dart';
import 'package:drp_basket_app/views/donor/rank_explaination_screen.dart';
import 'package:flutter/material.dart';
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
                  donation.donationInfo(),
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
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RankExplanationScreen()),
          ),
          child: Card(
            child: ListTile(
              leading: Icon(Icons.star),
              title: Text(rankString[getRank(donor['donation_count'])]!),
            ),
          ),
        ),
      ],
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
