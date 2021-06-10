import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  static const String id = "ContactListPage";

  const ContactListPage({Key? key}) : super(key: key);

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receiver List"),
      ),
      body: StreamBuilder(
          stream:
              _fireStore.collection("charities").doc("ex-charity").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            } else {
              final contactDS = (snapshot.data as DocumentSnapshot);
              final contactMap = (contactDS.data() as Map<String, dynamic>);
              final contactList = contactMap["contact_list"] as List;
              print((contactMap["contact_list"][0]
                  as Map<String, dynamic>)["Name"]);
              return ListView(
                children: contactList.map((e) {
                  print(e["Name"]);
                  print(e["Contact"]);
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e["Name"]),
                          Text(e["Contact"]),
                        ],
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
