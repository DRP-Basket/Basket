import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            // Description
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: 'Contact',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Add Contact"),
              onPressed: () {
                locator<FirebaseFirestoreInterface>().addContact(_titleController.text, _descController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

}
