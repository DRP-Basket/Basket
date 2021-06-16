import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/views/charity/utilities/utilities.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import 'donor_donation_form.dart';

class DonorDonations extends StatelessWidget {
  const DonorDonations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Donations'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Donate",
                ),
                Tab(
                  text: "History",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DonorDonationForm(),
              DonorDonationsPage(),
            ],
          )),
    );
  }
}

class DonorDonationsPage extends StatefulWidget {
  const DonorDonationsPage({Key? key}) : super(key: key);

  @override
  _DonorDonationsPageState createState() => _DonorDonationsPageState();
}

class _DonorDonationsPageState extends State<DonorDonationsPage> {
  @override
  Widget build(BuildContext context) {
    var _store = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: _store
          .collection('donors')
          .doc('wy-test-donor')
          .collection('donations')
          .snapshots(), // TODO change to current donor,
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Utilities.loading();
        }
        var donations = snapshot.data!.docs;
        return ListView(
          children: donations.map((DocumentSnapshot ds) {
            return StreamBuilder(
                stream: _store
                    .collection('donations')
                    .doc(ds.reference.id)
                    .snapshots(),
                builder: (BuildContext ctx,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  var donationMap =
                      snapshot.data!.data() as Map<String, dynamic>;
                  var donation =
                      Donation.buildFromMap(ds.reference.id, donationMap);
                  return Card(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: _displayDonation(donation),
                    ),
                  );
                });
          }).toList(),
        );
      },
    );
  }

  Widget _displayDonation(Donation donation) {
    return ExpandablePanel(
      header: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          donation.timeCreated.toString(),
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      collapsed: Container(
        child: ListTile(
          title: Text('Status'),
          subtitle: Text(donation.status),
        ),
      ),
      expanded: Column(
        children: [
          ListTile(
            title: Text('Status'),
            subtitle: Text(donation.status),
          ),
          ListTile(
            title: Text('Description'),
            subtitle: Text(
                donation.description == null ? '-' : donation.description!),
          ),
          ListTile(
            title: Text('Collect by'),
            subtitle: Text(donation.collectBy == null
                ? '-'
                : donation.collectBy.toString()),
          ),
        ],
      ),
    );
  }
}
