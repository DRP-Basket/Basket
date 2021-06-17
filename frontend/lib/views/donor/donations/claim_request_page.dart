import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/charity/donations/claim_request_form.dart';
import 'package:drp_basket_app/views/charity/utilities/utilities.dart';
import 'package:flutter/material.dart';

class DonorClaimRequestPage extends StatefulWidget {
  final ClaimRequest request;
  final Map<String, dynamic> charity;

  const DonorClaimRequestPage(this.request, this.charity, {Key? key})
      : super(key: key);

  @override
  _DonorClaimRequestPageState createState() =>
      _DonorClaimRequestPageState(request, charity);
}

class _DonorClaimRequestPageState extends State<DonorClaimRequestPage> {
  final ClaimRequest request;
  final Map<String, dynamic> charity;
  final store = FirebaseFirestore.instance; // sTODO

  _DonorClaimRequestPageState(this.request, this.charity);

  @override
  Widget build(BuildContext context) {
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
            _showCharityName(),
            request.showTimeCreated(),
            _showContactNumber(),
            request.showETA(),
            _showCharityDesc(),
            request.status == 'Pending' ? _respondButtons() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _showCharityName() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        charity['name'],
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
          charity['contact_number'],
        ),
      ),
    );
  }

  Widget _showCharityDesc() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_sharp),
            title: Text('About the Charity'),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text(charity['description']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _respondButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _acceptButton(),
          _declineButton(),
        ],
      ),
    );
  }

  Widget _acceptButton() {
    return _updateStatusButton(
      icon: Icons.check,
      label: 'Accept',
      color: Colors.green,
      newStatus: 'Accepted',
    );
  }

  Widget _declineButton() {
    return _updateStatusButton(
      icon: Icons.cancel_outlined,
      label: 'Decline',
      color: Colors.red,
      newStatus: 'Declined',
    );
  }

  Widget _updateStatusButton(
      {required IconData icon,
      required String label,
      required Color color,
      required String newStatus}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () {
        store
            .collection('charities')
            .doc(request.charityID)
            .collection('requests')
            .doc(request.requestID)
            .update({'status': newStatus});
        if (newStatus == 'Accepted') {
          store
              .collection('donations')
              .doc(request.donation.donationID)
              .update({'status': 'Claimed'});
        }
        Navigator.pop(context);
      },
    );
  }
}
