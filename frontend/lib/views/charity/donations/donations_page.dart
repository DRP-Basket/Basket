import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/donor/donations/donor_donation_form.dart';
import 'package:drp_basket_app/views/donor/rank.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import '../utilities/utilities.dart';
import 'donation_page.dart';

// Page displaying donations posted by donor

class CharityDonationsPage extends StatefulWidget {
  const CharityDonationsPage({Key? key}) : super(key: key);

  @override
  _CharityDonationsPageState createState() => _CharityDonationsPageState();
}

class _CharityDonationsPageState extends State<CharityDonationsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: locator<FirebaseFirestoreInterface>().getAvailableDonations(),
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
                    children: donations.map(
                      (DocumentSnapshot ds) {
                        var donation = Donation.buildFromMap(
                            ds.reference.id, ds.data() as Map<String, dynamic>);
                        return GestureDetector(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              // child: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              child: _donationTile(donation),
                                  // TODO: encapsulate card into this method coz it looks ugly af when loading
                                // ],
                              // ),
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
                    ).toList(),
                  );
          }
        },
      ),
    );
  }

  // TODO : info about portion and donor ranking
  Widget _donationTile(Donation donation) {
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>().getDonor(donation.donorID),
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
