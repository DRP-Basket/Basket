import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../locator.dart';

class Receiver {
  final String name;
  final String contact;
  final String location;
  final DateTime? lastClaimed;

  Receiver(this.name, this.contact, this.location, {this.lastClaimed: null});

  static Receiver buildFromMap(Map<String, dynamic> rm) {
    return Receiver(rm['name'], rm['contact'], rm['location'],
        lastClaimed: rm['last_claimed'].toDate());
  }

}

class ReceiverPage extends StatefulWidget {
  final String id;

  const ReceiverPage(this.id, {Key? key}) : super(key: key);

  @override
  _ReceiverPageState createState() => _ReceiverPageState(id);
}

class _ReceiverPageState extends State<ReceiverPage> {
  static DateFormat dateFormat = DateFormat('MMM d, y');

  final String id;

  _ReceiverPageState(this.id);

  // Loading widget while waiting for data
  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  // Displays general receiver information - name, contact, location
  Widget _receiverInfo(Receiver receiver) {
    return Column(
      children: [
        Text(
          receiver.name,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Card(
          child: ListTile(
              leading: Icon(Icons.call), title: Text(receiver.contact)),
        ),
        Card(
          child: ListTile(
              leading: Icon(Icons.home), title: Text(receiver.location)),
        ),
        Card(
          child: ListTile(
              leading: Icon(Icons.calendar_today_outlined),
              title: Text('Last Claimed'),
              subtitle: Text(receiver.lastClaimed == null
                  ? ' - '
                  : dateFormat.format(receiver.lastClaimed!))),
        ),
      ],
    );
  }

  // Displays donations claimed by the receiver in reverse chronological order
  Widget _donationsClaimed(String receiverID) {
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
          StreamBuilder(
            stream: locator<FirebaseFirestoreInterface>()
                .donationsClaimed(receiverID),
            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return _loading();
              } else {
                var donationsClaimed = snapshot.data!.docs;
                return Column(
                  children: donationsClaimed.map((DocumentSnapshot ds) {
                    return _donationClaimed(ds.reference.id);
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Displays info about a single donation claimed by the receiver (event name + date)
  Widget _donationClaimed(String id) {
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>().getDonationEvent(id),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return _loading();
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

  // Displays a receiver's information and donations claimed by the receiver
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
            var receiverMap = snapshot.data!.data() as Map<String, dynamic>;
            print(receiverMap);
            var receiver = Receiver.buildFromMap(receiverMap);
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _receiverInfo(receiver),
                      _donationsClaimed(id),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
