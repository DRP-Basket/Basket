import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../home_page.dart';
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
            actions: [
              IconButton(
                onPressed: () {
                  locator<UserController>().userSignOut();
                  Navigator.pushReplacementNamed(context, HomePage.id);
                },
                icon: Icon(Icons.logout),
              )
            ]),
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
