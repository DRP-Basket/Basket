import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/charity_donor.dart';
import 'package:drp_basket_app/views/charity/contact_list_page.dart';
import 'package:drp_basket_app/views/home_page.dart';
import 'package:flutter/material.dart';

import 'charity_donation_page.dart';

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
            title: Text('Events'),
            onTap: () => {
              Navigator.pushReplacementNamed(context, CharityDonationPage.id)
            },
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
            onTap: () =>
                Navigator.pushReplacementNamed(context, ContactListPage.id),
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
