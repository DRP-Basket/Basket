import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/charity_donor.dart';
import 'package:drp_basket_app/views/home_page.dart';
import 'package:flutter/material.dart';

import 'contacts/charity_receivers.dart';
import 'events/charity_events_page.dart';

class CharityDrawer extends StatelessWidget {
  const CharityDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("Charity"),
          ),
          ListTile(
            title: Text('Donation'),
            onTap: () =>
                {Navigator.popAndPushNamed(context, CharityEventsPage.id)},
          ),
          ListTile(
            title: Text('Donors'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CharityDonor()))
            },
          ),
          ListTile(
            title: Text('Receivers'),
            onTap: () => Navigator.popAndPushNamed(context, ReceiversList.id),
          ),
          ListTile(
              title: Text('Sign Out'),
              onTap: () async {
                await locator<UserController>().userSignOut();
                Navigator.pushReplacementNamed(context, HomePage.id);
              }),
        ],
      ),
    );
  }
}
