import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/general/donation.dart';
import 'package:drp_basket_app/views/donor/statistics/rank.dart';
import 'package:drp_basket_app/views/donor/statistics/rank_explaination_screen.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// Page displaying info about a specific donation, request to claim donation from here

class CharityDonationPage extends StatefulWidget {
  final Donation donation;

  const CharityDonationPage(this.donation, {Key? key}) : super(key: key);

  @override
  _CharityDonationPageState createState() =>
      _CharityDonationPageState(donation);
}

class _CharityDonationPageState extends State<CharityDonationPage> {
  final Donation donation;
  bool _uploading = false;

  _CharityDonationPageState(this.donation);

  @override
  Widget build(BuildContext context) {
    var _store = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(),
      body: _uploading
          ? loading()
          : StreamBuilder(
              stream:
                  _store.collection('donors').doc(donation.donorID).snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return loading();
                }
                var donor = snapshot.data!.data() as Map<String, dynamic>;
                return Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _donorInfo(donor),
                        donation.charityDisplay(),
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
          style: TextStyle(
            color: third_color,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Card(
          child: ListTile(
              leading: Icon(
                Icons.call,
                color: primary_color,
              ),
              title: Text(donor['contact_number'])),
        ),
        Card(
          child: ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blue[400],
              ),
              title: Text(donor['address'])),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RankExplanationScreen()),
          ),
          child: Card(
            child: ListTile(
              leading: Icon(
                Icons.star,
                color: Colors.yellow[800],
              ),
              title: Text(
                  rankString[getRank(donor['donation_count'])]!.capitalize()),
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
      onPressed: () async {
        await _getConfirmation(donation);
      },
    );
  }

  Future<dynamic> _getConfirmation(Donation donation) async {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to send a donation request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _uploading = true;
              });
              Navigator.pop(context);
              await Request.sendRequest(
                donorID: donation.donorID,
                donation: donation,
              );
              await _requestSuccess();
              setState(() {
                _uploading = false;
              });
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _requestSuccess() {
    return Alert(
        context: context,
        title: "Success",
        desc: "Claim request sent",
        type: AlertType.success,
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: primary_color,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]).show();
  }
}
