import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/views/charity/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../locator.dart';
import 'charity_drawer.dart';
import 'receiver.dart';

class ContactListPage extends StatefulWidget {
  static const String id = "ContactListPage";

  const ContactListPage({Key? key}) : super(key: key);

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receivers"),
      ),
      drawer: CharityDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddContact())),
      ),
      body: StreamBuilder(
          stream: locator<FirebaseFirestoreInterface>().getContactList(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          }),
    );
  }

  Widget _displayLastClaimed(Receiver receiver) {
    DateFormat dateFormat = DateFormat('MMM d, y');
    return Text(
        'Last Claimed: ${receiver.lastClaimed == null ? '-' : dateFormat.format(receiver.lastClaimed!)}');
  }
}
