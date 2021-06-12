import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/sms_controller/sms_controller.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'add_donation.dart';
import 'charity_drawer.dart';

class CharityDonationPage extends StatefulWidget {
  static const String id = "CharityDonationPage";

  const CharityDonationPage({Key? key}) : super(key: key);

  @override
  _CharityDonationPageState createState() => _CharityDonationPageState();
}

class _CharityDonationPageState extends State<CharityDonationPage> {
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
      appBar: AppBar(title: Text("Charity Donation Page")),
      drawer: CharityDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDonation()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
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
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            var donations = snapshot.data!.docs;
            donations.sort((a, b) {
              var aData = a.data() as Map<String, dynamic>;
              var bData = b.data() as Map<String, dynamic>;
              DateTime aDate = DateTime.parse(aData["date"]);
              DateTime bDate = DateTime.parse(bData["date"]);
              return aDate.compareTo(bDate);
            });
            return ListView(
              children: donations.map((DocumentSnapshot ds) {
                var donationID = ds.reference.id;
                var donation = ds.data() as Map<String, dynamic>;
                var title = donation['title'];
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                          title: Text('Date'),
                          subtitle: Text(donation['date']),
                        ),
                        ListTile(
                          title: Text('Location'),
                          subtitle: Text(donation['location']),
                        ),
                        ElevatedButton(
                            child: Text('Notify Receivers'),
                            onPressed: () => sendSMS(donationID, donation)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
