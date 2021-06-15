import 'package:flutter/material.dart';

import 'contacts/charity_receivers.dart';
import 'donations/donations_page.dart';
import 'events/charity_events_page.dart';

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
            title: Text('Events'),
            onTap: () => {Navigator.popAndPushNamed(context, CharityEventsPage.id)}, 
          ),
          ListTile(
            title: Text('Receivers'),
            onTap: () => Navigator.popAndPushNamed(context, ReceiversList.id),
          ),
          ListTile(
            title: Text('Donations'),
            onTap: () => Navigator.popAndPushNamed(context, CharityDonationsPage.id),
          ),
        ],
      ),
    );
  }
}