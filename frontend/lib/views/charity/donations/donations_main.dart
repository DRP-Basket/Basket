import 'package:flutter/material.dart';

import 'donors_page.dart';
import 'donations_page.dart';

// Controls tabs under <Donations> category

class DonationsMain extends StatelessWidget {
  static String id = "CharityDonationsMain";

  const DonationsMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(
                text: 'Browse Donations',
              ),
              Tab(
                text: 'Find Donors',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CharityDonationsPage(),
            DonorsPage(),
          ],
        ),
      ),
    );
  }
}
