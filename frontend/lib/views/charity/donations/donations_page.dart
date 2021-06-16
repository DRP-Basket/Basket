import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/donor/donations/donor_donation_form.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import '../charity_drawer.dart';
import '../utilities/utilities.dart';
import 'donation_page.dart';

// Page displaying donations posted by donor

class CharityDonationsPage extends StatefulWidget {
  static String id = "CharityDonationsPage";

  const CharityDonationsPage({Key? key}) : super(key: key);

  @override
  _CharityDonationsPageState createState() => _CharityDonationsPageState();
}

class _CharityDonationsPageState extends State<CharityDonationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Browse Donations')),
        drawer: CharityDrawer(),
        body: StreamBuilder(
            stream:
                locator<FirebaseFirestoreInterface>().getAvailableDonations(),
            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Utilities.loading();
              } else {
                var donations = snapshot.data!.docs;
                return donations.isEmpty
                    ? Center(
                        child: Text('No Donations Currently'),
                      )
                    : ListView(
                        children: donations.map((DocumentSnapshot ds) {
                          var donation = Donation.buildFromMap(ds.reference.id,
                              ds.data() as Map<String, dynamic>);
                          return GestureDetector(
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _donationTile(donation),
                                  ],
                                ),
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
                        }).toList(),
                      );
              }
            }));
  }

  // TODO : info about portion and donor ranking
  Widget _donationTile(Donation donation) {
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>().getDonor(donation.donorID),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Utilities.loading();
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
                leading: Icon(Icons.watch_later_sharp),
                title: Text('Collect By:'),
                subtitle: Text(formatDateTime(donation.collectBy)),
              ),
            ],
          ),
        );
      },
    );
  }
}
