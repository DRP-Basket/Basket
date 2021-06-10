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
    );
  }
}
