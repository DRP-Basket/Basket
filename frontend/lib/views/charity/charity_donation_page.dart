import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_donation.dart';
import 'charity_drawer.dart';

class CharityDonationPage extends StatefulWidget {
  static const String id = "CharityDonationPage";

  const CharityDonationPage({Key? key}) : super(key: key);

  @override
  _CharityDonationPageState createState() => _CharityDonationPageState();
}

class _CharityDonationPageState extends State<CharityDonationPage> {
  final Stream<QuerySnapshot> _donationsStream = FirebaseFirestore.instance
      .collection('charities')
      .doc('ex-charity')
      .collection('donations')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Charity Donation Page")),
      drawer: CharityDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDonation()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: _donationsStream,
          builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            }
            var donations = snapshot.data!.docs;
            return ListView(
              children: donations.map((DocumentSnapshot ds) {
                var donation = ds.data() as Map<String, dynamic>;
                var title = donation['title'];
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(title),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
