import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/general/donation.dart';
import 'package:drp_basket_app/views/donor/statistics/rank.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import 'donation_page.dart';

// Page displaying currently available donations (onTap -> `donation_page`)

class CharityDonationsPage extends StatefulWidget {
  final String? donorID;

  CharityDonationsPage({Key? key, String? this.donorID}) : super(key: key);

  @override
  _CharityDonationsPageState createState() =>
      _CharityDonationsPageState(donorID);
}

class _CharityDonationsPageState extends State<CharityDonationsPage> {
  final String? donorID;

  _CharityDonationsPageState(this.donorID);

  Future<Widget> _getImage(Donation donation) async {
    String downloadUrl = await locator<FirebaseStorageInterface>()
        .getImageUrl(UserType.DONOR, donation.donorID);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          // image:
          image: NetworkImage(downloadUrl),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.dstATop),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: _donationTile(donation),
    );
  }

  @override
  Widget build(BuildContext context) {

    var _store = FirebaseFirestore.instance;

    var all = _store.collection('available_donations');
    var dons = donorID == null
        ? all.orderBy(Donation.TIME_CREATED).snapshots()
        : all
            .where(Donation.DONOR_ID, isEqualTo: donorID)
            .orderBy(Donation.TIME_CREATED)
            .snapshots();

    return Container(
      child: StreamBuilder(
        stream: dons,
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Donations Currently',
                ),
              );
            }
            var donations = snapshot.data!.docs;
            return ListView(
              children: donations.map(
                (DocumentSnapshot ds) {
                  var donationID = ds.reference.id;
                  var donationMap = ds.data() as Map<String, dynamic>;
                  var donorID = donationMap['donor_id'];
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('donors')
                        .doc(donorID)
                        .collection('donation_list')
                        .doc(donationID)
                        .snapshots(),
                    builder: (BuildContext ctx,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData || snapshot.data!.data() == null)
                        return Container();
                      var donation = Donation.buildFromMap(donationID,
                          snapshot.data!.data() as Map<String, dynamic>);
                      return GestureDetector(
                        child: Card(
                          child: FutureBuilder(
                            future: _getImage(donation),
                            builder: (BuildContext context, snapshot) {
                              return snapshot.hasData
                                  ? snapshot.data as Widget
                                  : Container();
                            },
                          ),
                        ),
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CharityDonationPage(donation)))
                        },
                      );
                    },
                  );
                },
              ).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _donationTile(Donation donation) {
    return Column(
      children: [
        _donorInfo(donation.donorID),
        donation.displaySummary(),
      ],
    );
  }

  Widget _donorInfo(String donorID) {
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>().getDonor(donorID),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var donor = snapshot.data!.data() as Map<String, dynamic>;
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  donor['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.home),
                title: Text(donor['address']),
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.star),
                title: Text(rankString[getRank(donor['donation_count'])]!),
              ),
            ],
          ),
        );
      },
    );
  }
}
