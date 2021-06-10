import 'package:flutter/material.dart';

import 'charity_drawer.dart';

class CharityDonationPage extends StatelessWidget {
  static const String id = "CharityDonationPage";
  
  const CharityDonationPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Charity Donation Page")),
      drawer: CharityDrawer(),
    );
  }
}