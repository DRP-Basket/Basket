import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import '../charity_drawer.dart';
import '../utilities/utilities.dart';
import 'donation.dart';
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
                return ListView(
                  children: donations.map((DocumentSnapshot ds) {
                    var donation = Donation.buildFromMap(ds.reference.id, ds.data() as Map<String, dynamic>);
                    return GestureDetector(
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _donationTile(donation.donorID),
                            ],
                          ),
                        ),
                      ),
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CharityDonationPage(donation)))
                      },
                    );
                  }).toList(),
                );
              }
            }));
  }

  Widget _donationTile(String donorID) {
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>().getDonor(donorID),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Utilities.loading();
        }
        var donor = snapshot.data!.data() as Map<String, dynamic>;
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(donor['name']),
              Text(donor['contact_number']),
            ],
          ),
        );
      },
    );
  }
}
