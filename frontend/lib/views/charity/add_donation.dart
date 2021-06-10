import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDonation extends StatefulWidget {
  const AddDonation({Key? key}) : super(key: key);

  @override
  _AddDonationState createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Donation"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            // Description
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Add Donation"),
              onPressed: () {
                _addToFireBase();
                _notifyReceivers();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  final _fireStore = FirebaseFirestore.instance;

  Future<void> _addToFireBase() async {
    CollectionReference donations = await _fireStore.collection("charities").doc("ex-charity").collection("donations");
    return donations.add({
      'title': _titleController.text, 
      'desc': _descController.text,
    })
    .then((value) => print('Donation Added'))
    .catchError((err) => print("Failed to add donation: $err"));
  }

  void _notifyReceivers() {}

  
}
