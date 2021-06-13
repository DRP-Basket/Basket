import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../locator.dart';

class Receiver {
  final String name;
  final String contact;
  final String location;

  Receiver(this.name, this.contact, this.location);
}

class ReceiverPage extends StatefulWidget {
  final String id;

  const ReceiverPage(this.id, {Key? key}) : super(key: key);

  @override
  _ReceiverPageState createState() => _ReceiverPageState(id);
}

class _ReceiverPageState extends State<ReceiverPage> {
  final String id;

  _ReceiverPageState(this.id);

  Widget _receiverInfo(Map<String, dynamic> receiver) {
    String name = receiver['name'];
    String contact = receiver['contact'];
    String location = receiver['location'];
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Card(
          child: ListTile(leading: Icon(Icons.call), title: Text(contact)),
        ),
        Card(
          child: ListTile(leading: Icon(Icons.home), title: Text(location)),
        ),
      ],
    );
  }

  Widget _donationsClaimed(List<dynamic> donationsClaimed) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Donations Claimed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 0.5,
          ),
          ...donationsClaimed.map((donationID) => _donationClaimed(donationID)),
        ],
      ),
    );
  }

  Widget _donationClaimed(String id) {
    var dateFormat = DateFormat('MMM d, y');
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>().getDonationEvent(id),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          var donationEvent = snapshot.data!.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(
              donationEvent['event_name'],
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
                dateFormat.format(donationEvent['event_date_time'].toDate())),
            contentPadding: EdgeInsets.all(20),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: locator<FirebaseFirestoreInterface>().getReceiver(id),
        builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else {
            var receiver = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _receiverInfo(receiver),
                      _donationsClaimed(receiver['donations_claimed']),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
