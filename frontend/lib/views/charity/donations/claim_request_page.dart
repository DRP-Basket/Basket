import 'package:drp_basket_app/views/charity/utilities/form_utilities.dart';
import 'package:drp_basket_app/views/donor/donor.dart';
import 'package:flutter/material.dart';

import 'claim_request_form.dart';

class ClaimRequestPage extends StatefulWidget {
  final ClaimRequest request;
  final Donor donor;

  const ClaimRequestPage(this.request, this.donor, {Key? key})
      : super(key: key);

  @override
  _ClaimRequestPageState createState() =>
      _ClaimRequestPageState(request, donor);
}

class _ClaimRequestPageState extends State<ClaimRequestPage> {
  final ClaimRequest request;
  final Donor donor;

  _ClaimRequestPageState(this.request, this.donor);

  @override
  Widget build(BuildContext context) {

    void _collectedDonation() {
      String donorID = widget.donor.uid;

    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request to Claim Donation',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            request.showStatus(),
            _showDonorName(),
            request.showETA(),
            request.showTimeCreated(),
            _showContactNumber(),
            _showAddress(),
            request.donation.donationInfo(),
            FormUtilities.addButton(_collectedDonation, "Collected")
          ],
        ),
      ),
    );
  }

  Widget _showDonorName() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        donor.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _showContactNumber() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.call),
        title: Text('Contact Number'),
        subtitle: Text(
          donor.contact,
        ),
      ),
    );
  }

  Widget _showAddress() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.home),
        title: Text('Address'),
        subtitle: Text(
          donor.address,
        ),
      ),
    );
  }
}
