import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../locator.dart';
import 'donation_event.dart';

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
                _textField(name),
                dateTimePicker(),
                _textField(location),
                _textField(description, optional: true),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                    ),
                    child: Text(
                      "Add Event",
                      style: fieldStyle(),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var event = _formKey.currentState!.fields;
                        DonationEvent de = DonationEvent(
                            event[name]!.value,
                            event[location]!.value,
                            event[description]!.value,
                            event[dateAndTime]!.value);
                        locator<FirebaseFirestoreInterface>()
                            .addDonationEvent(de);
                        Navigator.pop(context);
                      }
                    })
              ],
            ),
          ),
        ));
  }

  InputDecoration fieldDecor(String fieldName, bool optional) {
    return InputDecoration(
      labelText: fieldName + (optional ? ' (optional)' : ' *'),
    );
  }

  TextStyle fieldStyle() => TextStyle(
        fontSize: 20,
      );

  Widget _textField(String fieldName, {bool optional: false}) {
    return FormBuilderTextField(
      style: fieldStyle(),
      name: fieldName,
      decoration: fieldDecor(fieldName, optional),
      validator: (value) {
        if (!optional && (value == null || value.isEmpty)) {
          return 'Please enter ${fieldName.toLowerCase()}';
        }
        return null;
      },
    );
  }

  Widget dateTimePicker() {
    return FormBuilderDateTimePicker(
      style: fieldStyle(),
      name: dateAndTime,
      inputType: InputType.both,
      decoration: fieldDecor(dateAndTime, false),
    );
  }
}
