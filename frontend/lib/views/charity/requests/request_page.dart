import 'package:drp_basket_app/views/general/donor.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  bool _uploading = false;

  _RequestPageState(this.request, this.donor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request to Claim Donation',
        ),
      ),
      body: _uploading
          ? loading()
          : Container(
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
                      : Card(child: request.donation!.display()),
                  !request.endState() ? Container() : request.getMessage(),
                  _actionByStatus(),
                  request.closed == null || !request.closed!
                      ? (request.endState() ? _closeButton() : Container())
                      : Container(),
                ],
              ),
            ),
    );
  }

  Widget _actionByStatus() {
    switch (request.status) {
      case Request.PING_ACCEPTED:
      case Request.POST_ACCEPTED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _getClaimButtons(),
        );
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
        color: Colors.deepOrange[800]!,
        onPressed: () {
          request.charityClose();
          Navigator.pop(context);
        });
  }

  List<Widget> _getClaimButtons() {
    return [
      Expanded(
        flex: 4,
        child: actionButton(
          icon: Icons.check,
          label: 'Successful',
          color: Colors.green,
          onPressed: () => _getConfirmation(true),
        ),
      ),
      Spacer(),
      Expanded(
        flex: 4,
        child: actionButton(
          icon: Icons.error_outline,
          label: 'Unsuccessful',
          color: Colors.red,
          onPressed: ()  => _getConfirmation(false),
        ),
      ),
    ];
  }

  Future<dynamic> _getConfirmation(bool successful) async {
    TextEditingController messageController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("This request is ${successful ? "" : "un"}successful"),
        content: TextField(
          decoration: InputDecoration(
            labelText: "Message (optional)",
            filled: true,
            fillColor: Colors.grey[250],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondary_color, width: 2.0),
            ),
            border: null,
          ),
          controller: messageController,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _uploading = true;
              });
              Navigator.pop(context);
              if (successful) {
                await request.claimed(messageController.text);
              } else {
                await request.unsuccessfulClaim(messageController.text);
              }
              await request.charityClose();
              await request.donorClose();
              await _requestSuccess();
              setState(() {
                _uploading = false;
              });
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _requestSuccess() {
    return Alert(context: context, title: "Status updated", buttons: [
      DialogButton(
        child: Text(
          "Okay",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: primary_color,
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    ]).show();
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
        request.charityClose();
        request.donorClose();
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
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: third_color,
        ),
      ),
    );
  }

  Widget _showContactNumber() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.call, color: primary_color),
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
        leading: Icon(Icons.home, color: Colors.blue[400]),
        title: Text('Address'),
        subtitle: Text(
          donor.address,
        ),
      ),
    );
  }
}
