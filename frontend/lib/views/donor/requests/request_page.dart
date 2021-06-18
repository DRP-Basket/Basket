import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/donations/donation_form.dart';
import 'package:drp_basket_app/views/requests/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  final Request request;
  final Map<String, dynamic> charity;

  const RequestPage(this.request, this.charity, {Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState(request, charity);
}

class _RequestPageState extends State<RequestPage> {
  final Request request;
  final Map<String, dynamic> charity;
  final _store = FirebaseFirestore.instance;

  _RequestPageState(this.request, this.charity);

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
            _showCharityInfo(),
            _showDonationInfo(),
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

  Widget _showCharityInfo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('About the Charity'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('Contact Number'),
            subtitle: Text(
              charity['contact_number'],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.info_sharp),
              title: Text('Description'),
              subtitle: Text(charity['description']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showDonationInfo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.favorite_outlined),
            title: Text('Your Donation'),
          ),
          Divider(),
          request.donation == null ? _emptyDonation() : _hasDonation(),
        ],
      ),
    );
  }

  Widget _hasDonation() {
    return Column(
      children: [
        request.donation!.display(
          showCharity: false,
        ),
        request.status == Request.POST_WAITING
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _acceptButton(),
                  _declineButton(),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _emptyDonation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _donateButton(),
        _declineButton(),
      ],
    );
  }

  Widget _acceptButton() {
    return actionButton(
      icon: Icons.check,
      label: 'Accept',
      color: Colors.green,
      onPressed: () {
        request.donorAccept();
        Navigator.pop(context);
      },
    );
  }

  Widget _declineButton() {
    return actionButton(
      icon: Icons.cancel_outlined,
      label: 'Decline',
      color: Colors.red,
      onPressed: () {
        request.donorDecline();
        Navigator.pop(context);
      },
    );
  }

  Widget _donateButton() {
    return actionButton(
      icon: Icons.volunteer_activism_sharp,
      label: 'Make a Donation',
      color: Colors.green,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => DonationForm(request: request),
          ),
        );
      },
    );
  }

}
