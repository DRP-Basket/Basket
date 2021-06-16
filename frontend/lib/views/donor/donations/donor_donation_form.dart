import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/views/charity/utilities/form_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../locator.dart';

class DonorDonationForm extends StatefulWidget {
  const DonorDonationForm({Key? key}) : super(key: key);

  @override
  _DonorDonationFormState createState() => _DonorDonationFormState();
}

class _DonorDonationFormState extends State<DonorDonationForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  static const String description = 'Description';
  static const String collectBy = 'Time to collect by';
  static const String addDonation = 'Donate Today';

  FormBuilderDateTimePicker dateTimePicker = FormUtilities.dateTimePicker(collectBy);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormBuilder(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  dateTimePicker,
                  FormUtilities.textField(description, optional: true),
                  SizedBox(
                    height: 20,
                  ),
                  FormUtilities.addButton(_addDonation, addDonation),
                ],
              ))),
    );
  }

  void _addDonation() {
    if (_formKey.currentState!.validate()) {
      var donation = _formKey.currentState!.fields;
      Donation.createAndAddDonation(
          donation[collectBy]!.value, donation[description]!.value);
      _formKey.currentState!.fields[collectBy]!.didChange(null);
      _formKey.currentState!.reset();
    }
  }

}

class Donation {
  late String donationID;
  String donorID;
  DateTime timeCreated;
  DateTime? collectBy;
  String? description;
  String status;

  Donation(
      {required this.donorID,
      required this.timeCreated,
      this.collectBy,
      this.description,
      this.status = 'Unclaimed'});

  static Donation createAndAddDonation(
      DateTime? collectBy, String? description) {
    Donation donation = Donation(
      donorID: _curDonorID(),
      timeCreated: DateTime.now(),
      collectBy: collectBy,
      description: description,
    );
    locator<FirebaseFirestoreInterface>().addDonation(donation);
    return donation;
  }

  static Donation buildFromMap(String id, Map<String, dynamic> donation) {
    Donation _donation = Donation(
      donorID: donation['donor_id'],
      timeCreated: donation['time_created'].toDate(),
      collectBy: donation['collect_by'] == null
          ? null
          : donation['collect_by'].toDate(),
      description: donation['description'],
      status: donation['status'],
    );
    _donation.donationID = id;
    return _donation;
  }

  static String _curDonorID() {
    return 'wy-test-donor';
  }
}
