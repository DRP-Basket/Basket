import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../locator.dart';
import 'charity_event.dart';
import '../../utilities/form_utilities.dart';

// Form to fill in when adding a new charity event

class CharityEventForm extends StatefulWidget {
  const CharityEventForm({Key? key}) : super(key: key);

  @override
  _CharityEventFormState createState() => _CharityEventFormState();
}

class _CharityEventFormState extends State<CharityEventForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final String uid = locator<UserController>().curUser()!.uid;
  static const String name = 'Event Name';
  static const String location = 'Event Location';
  static const String description = 'Event Description';
  static const String dateAndTime = 'Event Date And Time';
  static const String addDonationEventLabel = 'Add Event';
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Donation Event'),
        ),
        body: uploading
            ? loading()
            : SingleChildScrollView(
                child: FormBuilder(
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
                        FormUtilities.addButton(
                            _addDonationEvent, addDonationEventLabel),
                      ],
                    ),
                  ),
                ),
              ));
  }

  //TODO null checking
  Future<void> _addDonationEvent() async {
    if (_formKey.currentState!.validate()) {
      var event = _formKey.currentState!.fields;
      String? desc = event[description]!.value;
      DonationEvent de = DonationEvent(
          event[name]!.value,
          event[location]!.value,
          desc == null ? "" : desc,
          event[dateAndTime]!.value);
      setState(() {
        uploading = true;
      });
      await locator<FirebaseFirestoreInterface>().addDonationEvent(de);
      Navigator.pop(context);
    }
  }
}
