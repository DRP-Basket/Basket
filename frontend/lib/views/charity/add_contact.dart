import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../locator.dart';
import 'form_utilities.dart';
import 'receiver.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final _formKey = GlobalKey<FormBuilderState>();

  static const String name = 'Name';
  static const String contact = 'Contact Number';
  static const String location = 'Location';
  static const String addReceiverLabel = 'Add Receiver';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Receiver"),
      ),
      body: FormBuilder(
        key: _formKey, 
        child: Container(
          padding: EdgeInsets.all(20), 
          child: Column(
            children: [
              FormUtilities.textField(name),
              FormUtilities.textField(contact), 
              FormUtilities.textField(location),
              SizedBox(
                height: 20, 
              ),
              FormUtilities.addButton(_addReceiver, addReceiverLabel),
            ],
          ),
        ),
      )
    );
  }

  void _addReceiver() {
    if (_formKey.currentState!.validate()) {
      var receiver = _formKey.currentState!.fields;
      Receiver receiverToAdd = Receiver(
          receiver[name]!.value,
          receiver[contact]!.value,
          receiver[location]!.value);
      locator<FirebaseFirestoreInterface>()
          .addReceiver(receiverToAdd);
      Navigator.pop(context);
    }
  }

}
