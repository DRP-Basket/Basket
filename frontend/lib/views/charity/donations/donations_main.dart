import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/requests/requests_page.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../home_page.dart';
import '../charity_donor.dart';
import '../donor_page.dart';
import 'donations_page.dart';

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
            CharityDonor(),
          ],
        ),
      ),
    );
  }
}
