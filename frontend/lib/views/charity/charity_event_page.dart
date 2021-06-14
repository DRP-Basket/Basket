import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/views/charity/receiver.dart';
import 'package:flutter/material.dart';

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
                  List pendingList = (snapshot.data!.data() as Map<String, dynamic>)["confirmed"];
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
