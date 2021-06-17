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
    DonorRequests(),
    DonorProfilePage(),
  ];

  late User curUser;
  late final DonorInformationModel donorInformationModel;

  @override
  void initState() {
    super.initState();
    curUser = locator<UserController>().curUser()!;

    // TODO: LINK TO FIREBASE ACCOUNT
    donorInformationModel = DonorInformationModel(
        curUser.uid, "Vincent", "vincent@basket.com", "0123456789", 8000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
      ),
      body: Provider<DonorInformationModel>(
        create: (context) => donorInformationModel,
        child: _widgets[_currentIndex],
      ),
    );
  }
}
