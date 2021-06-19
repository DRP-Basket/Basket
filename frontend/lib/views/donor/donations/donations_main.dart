
import 'package:flutter/material.dart';

import 'donation_form.dart';
import 'donations_page.dart';

// Controls tabs under <Donations> category

class DonationsMain extends StatelessWidget {
  const DonationsMain({Key? key}) : super(key: key);

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
              DonationForm(),
              DonorDonationsPage(),
            ],
          )),
    );
  }
}