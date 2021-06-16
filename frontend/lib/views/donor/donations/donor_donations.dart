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
                  return GestureDetector(
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: _displayDonation(donation),
                      ),
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
      header: Text(donation.timeCreated.toString()),
      collapsed: Container(
        child: _getStatus(donation),
      ),
      expanded: Column(
        children: [
          ElevatedButton(
            child: Text('Mark as Claimed'),
            onPressed: () => {_markDonationClaimed(donation)},
          ),
          Text(
            'Description: ${donation.description == null ? '-' : donation.description}',
          ),
          Text(
            'Collect by: ${donation.collectBy == null ? '-' : donation.collectBy}',
          ),
        ],
      ),
    );
  }

  Widget _getStatus(Donation donation) {
    var status;
    if (donation.claimed) {
      status = 'Claimed';
    } else if (donation.collectBy != null &&
        DateTime.now().isAfter(donation.collectBy!)) {
      status = 'Expired';
    } else {
      status = 'Unclaimed';
    }
    return Text('Status: $status');
  }

  void _markDonationClaimed(Donation donation) {
    var _store = FirebaseFirestore.instance;
    _store.collection('donations').doc(donation.donationID).update({
      'claimed': true,
    });
  }
}
