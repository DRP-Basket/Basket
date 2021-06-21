import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/sms_controller/sms_controller.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/charity_profile_page.dart';
import 'package:drp_basket_app/views/charity/receivers/charity_receiver_form.dart';
import 'package:drp_basket_app/views/charity/receivers/charity_receivers.dart';
import 'package:drp_basket_app/views/charity/requests/requests_main.dart';
import 'package:drp_basket_app/views/welcome_page.dart';
import 'package:drp_basket_app/views/charity/donations/donations_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import 'charity_event_form.dart';
import 'charity_event_page.dart';

// Page displaying all events by a charity

class CharityEventsPage extends StatefulWidget {
  static const String id = "CharityEventsPage";

  const CharityEventsPage({Key? key}) : super(key: key);

  @override
  _CharityEventsPageState createState() => _CharityEventsPageState();
}

class _CharityEventsPageState extends State<CharityEventsPage> {
  final List<String> _titles = [
    "Donation Events",
    "Receivers",
    "My Requests",
    "Donors",
    "Your Profile",
  ];
  final List<Widget> _widgets = [];
  int _currentIndex = 0;
  late User curUser;
  CharityInformationModel? charityInformationModel = null;

  @override
  void initState() {
    super.initState();
    _widgets.add(_buildCharityEventsPage());
    _widgets.add(ReceiversList());
    _widgets.add(RequestsMain());
    _widgets.add(DonationsMain());
    _widgets.add(CharityProfilePage());
    curUser = locator<UserController>().curUser()!;

    locator<FirebaseFirestoreInterface>()
        .charityFromID(curUser.uid)
        .then((value) {
      Map<String, dynamic> charityData = value.data();
      setState(() {
        charityInformationModel = CharityInformationModel(
            curUser.uid,
            charityData["name"],
            charityData["email"],
            charityData["contact_number"],
            charityData["description"]);
      });
    });
  }

  String donationEventMsg(Map<String, dynamic> donation) {
    return 'Donation Event Happening!\n\'Event Name: ${donation['title']}\nEvent Location: ${donation['location']}\nEvent Time: ${donation['date']}';
  }

  void sendSMS(donationID, donationMap) async {
    String donationMessage = donationEventMsg(donationMap);
    bool success = await locator<SMSController>()
        .sendSMS(donationID, msgContent: donationMessage);
    if (success) {
      Alert(
          context: context,
          title: "Message Sent",
          desc: "Messages have been sent out",
          type: AlertType.success,
          buttons: [
            DialogButton(
              child: Text(
                "Exit",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ]).show();
    } else {
      Alert(
          context: context,
          title: "Message Failed",
          desc: "Messages have failed to send out",
          type: AlertType.warning,
          buttons: [
            DialogButton(
              child: Text(
                "Exit",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ]).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        actions: [
          IconButton(
            onPressed: () {
              locator<UserController>().userSignOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                  (route) => false);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[200],
        selectedItemColor: secondary_color,
        currentIndex: _currentIndex,
        iconSize: 26,
        selectedFontSize: 15,
        selectedIconTheme: IconThemeData(size: 30),
        items: [
          BottomNavigationBarItem(
            label: "Events",
            icon: Icon(Icons.event),
          ),
          BottomNavigationBarItem(
            label: "Receivers",
            icon: Icon(Icons.group),
          ),
          BottomNavigationBarItem(
            label: "Requests",
            icon: Icon(Icons.restaurant_menu),
          ),
          BottomNavigationBarItem(
            label: "Donations",
            icon: Icon(Icons.store),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: renderActionButton(),
      body: charityInformationModel != null
          ? Provider<CharityInformationModel>(
              create: (context) => charityInformationModel!,
              child: _widgets[_currentIndex])
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  FloatingActionButton? renderActionButton() {
    switch (_currentIndex) {
      case 0:
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CharityEventForm()));
          },
          backgroundColor: primary_color,
          label: Text("Add Event"),
          icon: Icon(Icons.add),
        );

      case 1:
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReceiverForm()));
          },
          backgroundColor: primary_color,
          label: Text("Add Receiver"),
          icon: Icon(Icons.add),
        );

      case 2:
      case 3:
        return null;
    }
  }

  Widget _buildCharityEventsPage() {
    return StreamBuilder(
        stream: locator<FirebaseFirestoreInterface>().getDonationList(),
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Events Posted Yet',
                style: TextStyle(
                  color: third_color,
                  fontSize: 24,
                ),
              ),
            );
          }
          var donations = snapshot.data!.docs;
          donations.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            Timestamp aDate = aData["event_date_time"];
            Timestamp bDate = bData["event_date_time"];
            return bDate.compareTo(aDate);
          });
          return ListView(
            children: donations.map((DocumentSnapshot ds) {
              var donationID = ds.reference.id;
              var donation = ds.data() as Map<String, dynamic>;
              String name = donation['event_name'];
              String location = donation['event_location'];
              DateTime dateTime = donation['event_date_time'].toDate();
              return GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CharityEventPage(
                              donationID: donationID, donationMap: donation)))
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                          title: Text('Date And Time'),
                          subtitle: Text(
                              DateFormat.yMMMd().add_jm().format(dateTime)),
                        ),
                        ListTile(
                          title: Text('Location'),
                          subtitle: Text(location),
                        ),
                        ElevatedButton(
                            child: Text('Notify Receivers'),
                            onPressed: () => sendSMS(donationID, donation)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }
}

class CharityInformationModel {
  final String uid;
  final String name;
  final String email;
  final String contactNumber;
  final String description;
  ImageProvider? imageProvider = null;

  CharityInformationModel(
      this.uid, this.name, this.email, this.contactNumber, this.description);

  void updateImage(ImageProvider imageProvider) {
    this.imageProvider = imageProvider;
  }
}
