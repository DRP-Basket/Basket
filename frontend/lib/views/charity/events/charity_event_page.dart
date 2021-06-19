import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import '../receivers/charity_receiver_page.dart';

// Page displaying details of charity event: confirmed & pending list of receivers attending the event

class CharityEventPage extends StatefulWidget {
  final String donationID;
  final Map<String, dynamic> donationMap;

  const CharityEventPage(
      {Key? key, required this.donationID, required this.donationMap})
      : super(key: key);

  @override
  _CharityEventPageState createState() => _CharityEventPageState();
}

class _CharityEventPageState extends State<CharityEventPage> {
  late String name;
  late String location;
  late DateTime dateTime;

  @override
  void initState() {
    name = widget.donationMap['event_name'];
    location = widget.donationMap['event_location'];
    dateTime = widget.donationMap['event_date_time'].toDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Confirmed",
              ),
              Tab(
                text: "Pending",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: locator<FirebaseFirestoreInterface>()
                  .getDonationEventSnapshot(widget.donationID),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                } else {
                  List confirmedList = (snapshot.data!.data() as Map<String, dynamic>)["confirmed"];
                  List pendingList = (snapshot.data!.data() as Map<String, dynamic>)["pending"];
                  if (pendingList.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Center(
                        child: Text(
                            "Please notify users by clicking on the notify button on the event's page",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (confirmedList.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Center(
                        child: Text(
                          "Please wait for users to confirm their attendance",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView(
                    children: confirmedList.map((receiver) {
                      String name = receiver['name'];
                      String contact = receiver['contact'];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ReceiverPage(receiver["uid"]))),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name),
                                Text(contact),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            StreamBuilder(
              stream: locator<FirebaseFirestoreInterface>()
                  .getDonationEventSnapshot(widget.donationID),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                } else {
                  List pendingList = (snapshot.data!.data() as Map<String, dynamic>)["pending"];
                  if (pendingList.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Center(
                        child: Text(
                            "Please notify users by clicking on the notify button on the event's page",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView(
                    children: pendingList.map((receiver) {
                      String name = receiver['name'];
                      String contact = receiver['contact'];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ReceiverPage(receiver["uid"]))),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name),
                                Text(contact),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
