import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/views/charity/utilities.dart';
import 'package:flutter/material.dart';

class AddDonation extends StatefulWidget {
  const AddDonation({Key? key}) : super(key: key);

  @override
  _AddDonationState createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController(text: 'Choose Event Date');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Donation Event"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Event Title',
              ),
            ),
            // Location
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Event Location',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Date
            DateTimePicker(_dateController),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Add Event"),
              onPressed: () {
                locator<FirebaseFirestoreInterface>().addDonation(_titleController.text, _locationController.text, _dateController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

