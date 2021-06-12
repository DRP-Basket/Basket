import 'package:drp_basket_app/views/charity/contact_list_page.dart';
import 'package:flutter/material.dart';

import 'charity_donation_page.dart';

class CharityDrawer extends StatelessWidget {
  const CharityDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, 
        children: [
          DrawerHeader(
            child: Text("Charity"),
          ),
          // ListTile(
          //   title: Text('Home'),
          //   onTap: () => {Navigator.popAndPushNamed(context, CharityHomePage.id)},
          // ),
          ListTile(
            title: Text('Donation'),
            onTap: () => {Navigator.popAndPushNamed(context, CharityDonationPage.id)}, 
          ),
          ListTile(
            title: Text('Receivers'),
            onTap: () => Navigator.popAndPushNamed(context, ContactListPage.id),
          ),
        ],
      ),
    );
  }
}