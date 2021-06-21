import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/user_type.dart';
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
  final bool displayPic;

  CharityDonationsPage(this.displayPic, {Key? key, String? this.donorID})
      : super(key: key);

  @override
  _CharityDonationsPageState createState() =>
      _CharityDonationsPageState(displayPic, donorID);
}

class _CharityDonationsPageState extends State<CharityDonationsPage> {
  final String? donorID;
  final bool displayPic;

  _CharityDonationsPageState(this.displayPic, this.donorID);

  Future<Widget> _getImage(Donation donation) async {
    String downloadUrl = await locator<FirebaseStorageInterface>()
        .getImageUrl(UserType.DONOR, donation.donorID);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.grey,
        ),
        color: Colors.grey[200],
      ),
      child: _donationTile(
        donation,
        NetworkImage(downloadUrl),
      ),
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
                    style: TextStyle(
                      color: third_color,
                      fontSize: 24,
                    ),
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
                            shadowColor: Colors.grey,
                            elevation: 3,
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
          }),
    );
  }

  Widget _donationTile(Donation donation, ImageProvider image) {
    return Column(
      children: [
        _donorInfo(donation, image),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: donation.displayCollectBy(),
        ),
      ],
    );
  }

  Widget _donorInfo(Donation donation, ImageProvider image) {
    String donorID = donation.donorID;
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>().getDonor(donorID),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var donor = snapshot.data!.data() as Map<String, dynamic>;
        List<Widget> children = [];
        if (displayPic) {
          children.add(Expanded(
            flex: 3,
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: CircleAvatar(
                  backgroundImage: image,
                  radius: 50,
                ),
              ),
            ),
          ));
        }
        List<Widget> columnChildren = [];
        if (displayPic) {
          columnChildren.add(Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Text(
                    donor['name'],
                    style: TextStyle(
                      color: third_color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
        columnChildren.addAll([
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 2.5,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  color: Colors.blue[400],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(donor['address']),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 2.5,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(rankString[getRank(donor['donation_count'])]!
                      .capitalize()),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 2.5,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.food_bank_outlined,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text("${donation.portions} portions"),
                ),
              ],
            ),
          ),
        ]);
        children.addAll([
          Expanded(
            flex: 6,
            child: Column(
              children: columnChildren,
            ),
          ),
        ]);
        return Row(
          children: children,
        );
      },
    );
  }
}
