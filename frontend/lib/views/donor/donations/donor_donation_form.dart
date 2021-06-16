import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/views/charity/utilities/form_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../locator.dart';

class DonorDonationForm extends StatefulWidget {
  const DonorDonationForm({ Key? key }) : super(key: key);

  @override
  _DonorDonationFormState createState() => _DonorDonationFormState();
}

class _DonorDonationFormState extends State<DonorDonationForm> {
  
  final _formKey = GlobalKey<FormBuilderState>();
  static const String description = 'Description';
  static const String collectBy = 'Time to collect by';
  static const String addDonation = 'Donate Today';


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormBuilder(
        key: _formKey, 
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FormUtilities.textField(description, optional: true),
              FormUtilities.dateTimePicker(collectBy), 
              SizedBox(height: 20,),
              FormUtilities.addButton(_addDonation, addDonation),
            ],
          )
        )
      ),
    );
  }

  void _addDonation() {
    if (_formKey.currentState!.validate()) {
      var donation = _formKey.currentState!.fields;
      Donation donationToAdd = Donation(
        'wy-test-donor', // TODO: change to use current uid
        DateTime.now(),
        donation[collectBy]!.value,
        donation[description]!.value,
        false,
      );
      locator<FirebaseFirestoreInterface>().addDonation(donationToAdd);
      // Navigator.pop(context);
    }
  }

}

class Donation {
  String donorID;
  DateTime timeCreated;
  DateTime? collectBy;
  String? description;
  bool claimed;
  String donationID;

  Donation(this.donorID, this.timeCreated, this.collectBy, this.description, this.claimed, {this.donationID = ''});

  static Donation buildFromMap(String id, Map<String, dynamic> donation) {
    var donorID = donation['donor_id'];
    var timeCreated = donation['time_created'].toDate();
    var collectBy = donation['collect_by'] != null ? donation['collect_by'].toDate() : null;
    var description = donation['description'];
    var claimed = donation['claimed'];
    var donationID = id;
    return Donation(donorID, timeCreated, collectBy, description, claimed, donationID: donationID);
  }
}