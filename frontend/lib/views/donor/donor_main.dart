import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../locator.dart';
import 'donations/donor_donations.dart';
import 'donor_home_page.dart';
import 'donor_profile_page.dart';
import 'donor_requests.dart';
import 'requests/requests_page.dart';

class DonorMain extends StatefulWidget {
  static const String id = "DonorMain";

  const DonorMain({Key? key}) : super(key: key);

  @override
  _DonorMainState createState() => _DonorMainState();
}

class _DonorMainState extends State<DonorMain> {
  int _currentIndex = 0;

  final List<Widget> _widgets = [
    DonorDonations(),
    RequestsPage(),
    DonorProfilePage(),
  ];

  late User curUser;
  DonorInformationModel? donorInformationModel = null;

  @override
  void initState() {
    super.initState();
    curUser = locator<UserController>().curUser()!;

    locator<FirebaseFirestoreInterface>()
        .getCollection("donors")
        .doc(curUser.uid)
        .get()
        .then((value) {
      Map<String, dynamic> donorData = value.data();
      setState(() {
        donorInformationModel = DonorInformationModel(
            curUser.uid,
            donorData["name"],
            donorData["email"],
            donorData["address"],
            donorData["contact_number"],
            8000);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: donorInformationModel != null
          ? BottomNavigationBar(
              backgroundColor: Colors.grey[200],
              selectedItemColor: secondary_color,
              currentIndex: _currentIndex,
              iconSize: 26,
              selectedFontSize: 15,
              selectedIconTheme: IconThemeData(size: 30),
              items: [
                BottomNavigationBarItem(
                  label: "Donations",
                  icon: Icon(Icons.favorite_outline_rounded),
                ),
                BottomNavigationBarItem(
                  label: "Requests",
                  icon: Icon(Icons.food_bank_outlined),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(Icons.store_outlined),
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
          : null,
      body: donorInformationModel == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Provider<DonorInformationModel>(
              create: (context) => donorInformationModel!,
              child: _widgets[_currentIndex],
            ),
    );
  }
}
