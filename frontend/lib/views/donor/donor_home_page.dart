import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donor/donor_add_item.dart';
import 'package:drp_basket_app/views/donor/donor_profile_page.dart';
import 'package:drp_basket_app/views/donor/donor_requests.dart';
import 'package:drp_basket_app/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorHomePage extends StatefulWidget {
  static const String id = "DonorHomePage";

  const DonorHomePage({Key? key}) : super(key: key);

  @override
  _DonorHomePageState createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  final List<String> _titles = [
    "Donation Listings",
    "Charity Requests",
    "Vincent's Store", // TODO: DONOR NAME
  ];
  final List<Widget> _widgets = [];
  int _currentIndex = 0;
  late User curUser;
  late final DonorInformationModel donorInformationModel;

  @override
  void initState() {
    super.initState();
    _widgets.add(DonorHomePage());
    _widgets.add(DonorRequests());
    _widgets.add(DonorProfilePage());
    curUser = locator<UserController>().curUser()!;

    // TODO: LINK TO FIREBASE ACCOUNT
    donorInformationModel = DonorInformationModel(curUser.uid, "Vincent",
        "vincent@basket.com", "180 Queen's Gate", "0123456789");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        actions: _currentIndex == 2
            ? [
                IconButton(
                  onPressed: () {
                    locator<UserController>().userSignOut();
                    Navigator.pushReplacementNamed(context, HomePage.id);
                  },
                  icon: Icon(Icons.logout),
                )
              ]
            : [],
      ),
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
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DonorAddItem()));
              },
              child: Icon(Icons.add),
              backgroundColor: secondary_color,
            )
          : null,
      body: Provider<DonorInformationModel>(
          create: (context) => donorInformationModel,
          child: _widgets[_currentIndex]),
    );
  }

  Widget DonorHomePage() {
    return StreamBuilder(
        stream: locator<FirebaseFirestoreInterface>()
            .getCollection("restaurants")
            .doc("vincent's store")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else {
            final foodDS = (snapshot.data as DocumentSnapshot);
            final foodMap = (foodDS.data() as Map<String, dynamic>);
            List<Widget> foodItems = [];
            for (var food in foodMap.keys) {
              foodItems.add(Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(food),
                      Text(foodMap[food].toString()),
                    ],
                  ),
                ),
              ));
            }
            return ListView(
              children: foodItems,
            );
          }
        });
  }
}

class DonorInformationModel {
  final String uid;
  final String name;
  final String email;
  final String address;
  final String contactNumber;
  ImageProvider? imageProvider = null;

  DonorInformationModel(
      this.uid, this.name, this.email, this.address, this.contactNumber);

  void updateImage(ImageProvider imageProvider) {
    this.imageProvider = imageProvider;
  }
}
