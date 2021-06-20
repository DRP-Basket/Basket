import 'package:drp_basket_app/constants.dart';
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
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.25),
                  bottom: BorderSide(color: Colors.grey, width: 0.25),
                ),
              ),
              child: TabBar(
                indicatorColor: secondary_color,
                indicatorWeight: 3.5,
                labelColor: third_color,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Browse Donations",
                  ),
                  Tab(
                    text: "Find Donors",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CharityDonationsPage(),
                  DonorsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
