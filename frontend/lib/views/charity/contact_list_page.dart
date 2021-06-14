import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/views/charity/add_contact.dart';
import 'package:flutter/material.dart';

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
                  var receiver = ds.data() as Map<String, dynamic>;
                  String name = receiver['name'];
                  String contact = receiver['contact'];
                  String location = receiver['location'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => ReceiverPage(receiverID)));
                    },
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
          }),
    );
  }
}
