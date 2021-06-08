import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../view_controllers/user_controller.dart';
import 'donor_profile_page.dart';

class DonorDrawer extends StatelessWidget {
  const DonorDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader(),
          ListTile(
            title: Text('Home'), 
            onTap: () => {Navigator.popAndPushNamed(context, DonorProfilePage.id)},
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () => {Navigator.popAndPushNamed(context, DonorProfilePage.id)},
          )
        ],
      ),
    );
  }

  Widget drawerHeader() {
    // TODO: implement usernames
    // TODO: profile pic
    String username = '<TODO: Username>';
    String email = locator<UserController>().curUserEmail();

    return UserAccountsDrawerHeader(
      accountName: Text(username),
      accountEmail: Text(email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://i.pinimg.com/originals/59/54/b4/5954b408c66525ad932faa693a647e3f.jpg'),
      ),
    );
  }
}
