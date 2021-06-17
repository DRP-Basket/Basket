import 'package:flutter/material.dart';

import '../charity_drawer.dart';
import 'claim_requests.dart';
import 'donations_page.dart';

class DonationsMain extends StatelessWidget {
  static String id = "CharityDonationsMain";

  const DonationsMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: CharityDrawer(),
        appBar: AppBar(
          title: Text('Donations'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Browse',
              ),
              Tab(
                text: 'My Requests',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CharityDonationsPage(),
            ClaimRequests(),
          ],
        ),
      ),
    );
  }
}
