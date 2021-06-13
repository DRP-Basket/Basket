import 'package:drp_basket_app/views/donor/donor_requests.dart';
import 'package:drp_basket_app/views/home_page.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../view_controllers/user_controller.dart';
import 'donor.dart';
import 'donor_home_page.dart';
import 'donor_profile_page.dart';

class DonorDrawer extends StatelessWidget {
  const DonorDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var curUser = locator<UserController>().curUser()!;
    var curUID = curUser.uid;
    var curUserEmail = curUser.email!;
    var curUserName = "Donor"; // TEST USER NAME
    var curUserPhoneNumber = "0123456789"; // TEST PHONE NUMBER
    return donorDrawer(
        context, Donor(curUID, curUserName, curUserEmail, curUserPhoneNumber));
    // return FutureBuilder<DocumentSnapshot>(
    //     future: snapshot,
    //     builder:
    //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         Map<String, dynamic> data =
    //             snapshot.data!.data()! as Map<String, dynamic>;
    //         print(data);
    //         // TEST PHONE NUMBER
    //         Donor donor =
    //             Donor(curUID, data['name'], curUserEmail, "0123456789");
    //         return donorDrawer(context, donor);
    //       }
    //       return Drawer();
    //     });
  }

  Widget donorDrawer(BuildContext context, Donor donor) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader(donor),
          ListTile(
            title: Text('Donation'),
            onTap: () => {Navigator.popAndPushNamed(context, DonorHomePage.id)},
          ),
          ListTile(
            title: Text('Requests'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DonorRequests()))
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () =>
                {Navigator.popAndPushNamed(context, DonorProfilePage.id)},
          ),
          ListTile(
            title: Text('Sign out'),
            onTap: () async {
              await locator<UserController>().userSignOut();
              Navigator.popAndPushNamed(context, HomePage.id);
            },
          )
        ],
      ),
    );
  }

  Widget drawerHeader(Donor donor) {
    // TODO: profile pic
    return UserAccountsDrawerHeader(
      accountName: Text(donor.name),
      accountEmail: Text(donor.email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://i.pinimg.com/originals/59/54/b4/5954b408c66525ad932faa693a647e3f.jpg'),
      ),
    );
  }
}
