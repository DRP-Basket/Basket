import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/donor/donations/donation_form.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constants.dart';

// Page displaying info about a single request

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
  bool _uploading = false;

  _RequestPageState(this.request, this.charity);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      request.showStatus(),
      _showCharityName(),
      request.showTimeCreated(),
      _showCharityInfo(),
    ];
    children.addAll(_showDonationInfo());
    if (request.closed != null && request.closed!) {
      children.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          "Message",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ));
      children.add(Text(request.message != null && request.message != ""
          ? request.message!
          : "N/A"));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request for Donation',
        ),
      ),
      body: !_uploading
          ? Container(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: children,
              ),
            )
          : loading(),
    );
  }

  Widget _showCharityName() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        charity['name'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: third_color,
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
            leading: Icon(Icons.call, color: primary_color),
            title: Text('Contact Number'),
            subtitle: Text(
              charity['contact_number'],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_sharp, color: Colors.blue[400]),
            title: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('Description'),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(charity['description']),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _showDonationInfo() {
    List<Widget> children = [];
    if (request.donation != null) {
      children.add(
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.favorite_outlined,
                  color: Colors.red,
                ),
                title: Text('Your Donation'),
              ),
              Divider(),
              _hasDonation(),
            ],
          ),
        ),
      );
    }
    request.donation == null && !request.closed!
        ? children.add(_emptyDonation())
        : children.add(_getButtons());
    return children;
  }

  Widget _hasDonation() {
    return Column(
      children: [
        request.donation!.display(
          showCharity: false,
        ),
        if (request.status == Request.POST_DECLINED) request.getMessage(),
      ],
    );
  }

  Widget _getButtons() {
    return request.status == Request.POST_WAITING
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                request.status == Request.POST_WAITING
                    ? _acceptButton()
                    : _donateButton(),
                _declineButton(),
              ],
            ),
          )
        : Container();
  }

  Widget _emptyDonation() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _donateButton(),
          _declineButton(),
        ],
      ),
    );
  }

  Widget _acceptButton() {
    return actionButton(
      fontSize: 21,
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
    TextEditingController messageController = TextEditingController();
    return actionButton(
      fontSize: 21,
      icon: Icons.cancel_outlined,
      label: 'Decline',
      color: Colors.red,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Decline Request"),
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
                await request.donorDecline(
                  message: messageController.text,
                );
                await _declineSuccesss();
                setState(() {
                  _uploading = false;
                });
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _declineSuccesss() {
    return Alert(
      context: context,
      title: "Request Declined",
      buttons: [
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
      ],
    ).show();
  }

  Widget _donateButton() {
    return actionButton(
      fontSize: 22,
      icon: Icons.volunteer_activism_sharp,
      label: 'Donate',
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
