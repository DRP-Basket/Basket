import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../locator.dart';
import 'donation_event.dart';
import 'form_utilities.dart';

class DonationEventForm extends StatefulWidget {
  const DonationEventForm({Key? key}) : super(key: key);

  @override
  _DonationEventFormState createState() => _DonationEventFormState();
}

class _DonationEventFormState extends State<DonationEventForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  static const String name = 'Event Name';
  static const String location = 'Event Location';
  static const String description = 'Event Description';
  static const String dateAndTime = 'Event Date And Time';
  static const String addDonationEventLabel = 'Add Event';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Donation Event'),
        ),
        body: FormBuilder(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                FormUtilities.textField(name),
                FormUtilities.dateTimePicker(dateAndTime),
                FormUtilities.textField(location),
                FormUtilities.textField(description, optional: true),
                SizedBox(
                  height: 30,
                ),
                FormUtilities.addButton(_addDonationEvent, addDonationEventLabel),
              ],
            ),
          ),
        ));
  }

  void _addDonationEvent() {
    if (_formKey.currentState!.validate()) {
      var event = _formKey.currentState!.fields;
      DonationEvent de = DonationEvent(
          event[name]!.value,
          event[location]!.value,
          event[description]!.value,
          event[dateAndTime]!.value);
      locator<FirebaseFirestoreInterface>().addDonationEvent(de);
      Navigator.pop(context);
    }
    
  }
}
