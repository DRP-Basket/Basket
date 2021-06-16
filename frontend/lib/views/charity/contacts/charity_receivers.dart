import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import '../charity_drawer.dart';
import 'charity_receiver.dart';
import 'charity_receiver_form.dart';
import 'charity_receiver_page.dart';

// Page showing all receiver contacts

class ReceiversList extends StatefulWidget {
  static const String id = "ContactListPage";

  const ReceiversList({Key? key}) : super(key: key);

  @override
  _ReceiversListState createState() => _ReceiversListState();
}

class _ReceiversListState extends State<ReceiversList> {
  bool sortByLastClaimed = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: locator<FirebaseFirestoreInterface>()
            .getContactList(sortByLastClaimed: sortByLastClaimed),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else {
            var receivers = snapshot.data!.docs;
            return ListView(
              children: receivers.map((DocumentSnapshot ds) {
                var receiverID = ds.reference.id;
                var receiverMap = ds.data() as Map<String, dynamic>;
                var receiver = Receiver.buildFromMap(receiverMap);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ReceiverPage(receiverID)));
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receiver.name,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              _displayLastClaimed(receiver),
                            ],
                          ),
                          Text(receiver.contact),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  Widget _displayLastClaimed(Receiver receiver) {
    DateFormat dateFormat = DateFormat('MMM d, y');
    return Text(
        'Last Claimed: ${receiver.lastClaimed == null ? '-' : dateFormat.format(receiver.lastClaimed!)}');
  }

// Widget _getSortedReceivers() {
//   if (sortByLastClaimed) {

//   }
// }

}
