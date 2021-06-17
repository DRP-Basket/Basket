// Form when making claim requests

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/charity/utilities/form_utilities.dart';
import 'package:drp_basket_app/views/donor/donations/donor_donation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'donations_main.dart';

class ClaimRequestForm extends StatefulWidget {
  final Donation donation;
  const ClaimRequestForm(this.donation, {Key? key}) : super(key: key);

  @override
  _ClaimRequestFormState createState() => _ClaimRequestFormState(donation);
}

class _ClaimRequestFormState extends State<ClaimRequestForm> {
  
  final Donation donation;
  final _formKey = GlobalKey<FormBuilderState>();

  static const String eta = 'Estimated Time of Arrival';
  static const String send = 'Send request';

  _ClaimRequestFormState(this.donation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send request to claim donation'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FormUtilities.dateTimePicker(eta),
              FormUtilities.addButton(_sendRequest, send),
            ],
          ),
        ),
      ),
    );
  }

  void _sendRequest() {
    if (_formKey.currentState!.validate()) {
      var request = _formKey.currentState!.fields;
      ClaimRequest.sendClaimRequest(donation, request[eta]!.value);
      Navigator.popUntil(context, ModalRoute.withName(DonationsMain.id));
    }
  }
}

class ClaimRequest {
  late final String requestID;
  final Donation donation;
  final String charityID;
  final DateTime eta;
  final DateTime timeCreated;
  final String status;

  ClaimRequest(
      {required this.donation,
      required this.charityID,
      required this.eta,
      required this.timeCreated,
      this.status: 'Pending'});

  //TODO factor out firestore, implement error checking
  static ClaimRequest sendClaimRequest(Donation donation, DateTime eta) {
    ClaimRequest req = ClaimRequest(
      donation: donation,
      charityID: _curCharityID(),
      eta: eta,
      timeCreated: DateTime.now(),
    );
    var store = FirebaseFirestore.instance;
    store
        .collection('charities')
        .doc(req.charityID)
        .collection('requests')
        .add({
      'donation_id': req.donation.donationID,
      'eta': req.eta,
      'time_created': req.timeCreated,
      'status': req.status,
    }).then((value) {
      req.requestID = value.id;
      store
          .collection('donations')
          .doc(req.donation.donationID)
          .collection('requests')
          .doc(value.id)
          .set({'charity_id': req.charityID});
    });
    return req;
  }

  static String _curCharityID() {
    return 'wy-test-charity';
  }

  static ClaimRequest buildFromMap(String id, Map<String, dynamic> req, Donation donation) {
    var _req =  ClaimRequest(
      donation: donation,
      charityID: _curCharityID(),
      eta: req['eta'].toDate(),
      timeCreated: req['time_created'].toDate(),
      status: req['status'],
    );
    _req.requestID = id;
    return _req;
  }

  static Widget? getIcon(String _status) {
    var status = _status.toLowerCase();
    return (status == 'pending')
        ? Icon(
            Icons.pending_actions_outlined,
            color: Colors.orange,
            size: 40,
          )
        : (status == 'accepted')
            ? Icon(
                Icons.gpp_good_outlined,
                color: Colors.green,
                size: 40,
              )
            : (status == 'declined')
                ? Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 40,
                  )
                : null;
  }
}
