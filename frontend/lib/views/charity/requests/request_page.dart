import 'package:drp_basket_app/views/general/donor.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

// Page displaying info about a specific request 

class RequestPage extends StatefulWidget {
  final Request request;
  final Donor donor;

  const RequestPage(this.request, this.donor, {Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState(request, donor);
}

class _RequestPageState extends State<RequestPage> {
  final Request request;
  final Donor donor;

  _RequestPageState(this.request, this.donor);

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
            request.showStatus(isDonor: false),
            _showDonorName(),
            request.showTimeCreated(),
            _showContactNumber(),
            _showAddress(),
            request.donation == null
                ? Container()
                : request.donation!.display(),
            _actionByStatus(),
            request.endState() ? _closeButton() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _actionByStatus() {
    switch (request.status) {
      case Request.PING_ACCEPTED:
      case Request.POST_ACCEPTED:
        return _claimButton();
      case Request.PING_DONOR_WAITING:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _acceptButton(),
            _declineButton(),
          ],
        );
      case Request.PING_CLAIMED:
      case Request.POST_CLAIMED:
        // return _rateButton();
      default:
        return Container();
    }
  }

  Widget _closeButton() {
    return actionButton(
      label: 'Close Request', 
      color: primary_color, 
      onPressed: () {
        request.charityClose();
        Navigator.pop(context);
      }
    );
  }

  Widget _claimButton() {
    return actionButton(
      icon: Icons.check,
      label: 'Claim',
      color: Colors.green,
      onPressed: () {
        request.claimed();
        Navigator.pop(context);
      },
    );
  }

  Widget _rateButton() {
    return actionButton(
      icon: Icons.rate_review_sharp,
      label: 'Rate',
      color: primary_color,
      onPressed: () {
        // TODO
      },
    );
  }

  Widget _acceptButton() {
    return actionButton(
      icon: Icons.check,
      label: 'Accept',
      color: Colors.green,
      onPressed: () {
        request.charityAccept();
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
        request.charityDecline();
        Navigator.pop(context);
      },
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
          donor.contactNumber,
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
