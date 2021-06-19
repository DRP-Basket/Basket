import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/general/donation.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class Request {
  late String id;
  String charityID;
  String donorID;
  Donation? donation;
  DateTime timeCreated;
  String status;

  Request({
    required this.charityID,
    required this.donorID,
    this.donation,
    required this.timeCreated,
    required this.status,
  });

  static var curUser = locator<UserController>().curUser()!;
  var _store = FirebaseFirestore.instance;

  // Status keywords
  static const PING_CHARITY_WAITING = 'ping_charity_waiting';
  static const PING_DONOR_WAITING = 'ping_donor_waiting';
  static const POST_WAITING = 'post_waiting';
  static const PING_ACCEPTED = 'ping_accepted';
  static const POST_ACCEPTED = 'post_accepted';
  static const PING_DONOR_DECLINED = 'ping_donor_declined';
  static const PING_CHARITY_DECLINED = 'ping_charity_declined';
  static const POST_DECLINED = 'post_declined';
  static const PING_CLAIMED = 'ping_claimed';
  static const POST_CLAIMED = 'post_claimed';

  // Firestore field names
  static const CHARITY_ID = 'charity_id';
  static const DONOR_ID = 'donor_id';
  static const DONATION_ID = 'donation_id';
  static const STATUS = 'status';
  static const TIME_CREATED = 'time_created';

  static Request buildFromMap(
      String id, Map<String, dynamic> req, Donation? donation) {
    Request request = Request(
      charityID: req[CHARITY_ID],
      donorID: req[DONOR_ID],
      donation: donation,
      timeCreated: req[TIME_CREATED].toDate(),
      status: req[STATUS],
    );
    request.id = id;
    return request;
  }

  static Request sendRequest({required String donorID, Donation? donation}) {
    Request req = Request(
      charityID: curUser.uid,
      donorID: donorID,
      donation: donation,
      timeCreated: DateTime.now(),
      status: donation == null ? PING_CHARITY_WAITING : POST_WAITING,
    );
    req.fsSendRequest();
    return req;
  }

  void fsSendRequest() {
    // Save request in charity's requests collection
    _store
        .collection('charities')
        .doc(charityID)
        .collection('request_list')
        .add({
      CHARITY_ID: charityID,
      DONOR_ID: donorID,
      DONATION_ID: donation?.id,
      TIME_CREATED: timeCreated,
      STATUS: status,
    }).then((requestRef) {
      // Save newly created request id
      id = requestRef.id;
      // Add to donor's side
      _store
          .collection('donors')
          .doc(donorID)
          .collection('request_list')
          .doc(id)
          .set({
        CHARITY_ID: charityID,
        TIME_CREATED: timeCreated,
      });
      // Add to donation's list if present
      if (donation != null) {
        addRequestToDonation(donation!);
      }
    });
  }

  void fsUpdate(Map<String, dynamic> fields) {
    _store
        .collection('charities')
        .doc(charityID)
        .collection('request_list')
        .doc(id)
        .update(fields);
  }

  void addRequestToDonation(Donation donation) {
    _store
        .collection('donors')
        .doc(donorID)
        .collection('donation_list')
        .doc(donation.id)
        .collection('requests')
        .doc(id)
        .set({
      CHARITY_ID: charityID,
      TIME_CREATED: timeCreated,
    });
  }

  // Donor Actions ------------------------------------------------------
  void respond(Donation donation) {
    assert(status == PING_CHARITY_WAITING);
    fsUpdate({
      DONATION_ID: donation.id,
      STATUS: PING_DONOR_WAITING,
    });
    addRequestToDonation(donation);
  }

  void donorDecline() {
    String newStatus = '';
    switch (status) {
      case POST_WAITING:
        newStatus = POST_DECLINED;
        break;
      case PING_CHARITY_WAITING:
        newStatus = PING_DONOR_DECLINED;
        break;
      default:
        assert(false);
    }
    fsUpdate({
      STATUS: newStatus,
    });
  }

  void donorAccept() {
    assert(status == POST_WAITING);
    fsUpdate({
      STATUS: POST_ACCEPTED,
    });
    donation!.assignToCharity(charityID);
  }

  // Charity Actions ------------------------------------------------------

  void charityAccept() {
    assert(status == PING_DONOR_WAITING);
    fsUpdate({
      STATUS: PING_ACCEPTED,
    });
  }

  void charityDecline() {
    assert(status == PING_DONOR_WAITING);
    fsUpdate({
      STATUS: PING_CHARITY_DECLINED,
    });
    // TODO : canceled status
  }

  void claimed() {
    String newStatus = '';
    switch (status) {
      case POST_ACCEPTED:
        newStatus = POST_CLAIMED;
        break;
      case PING_ACCEPTED:
        newStatus = PING_CLAIMED;
        break;
      default:
        assert(false);
    }
    fsUpdate({
      STATUS: newStatus,
    });
    locator<FirebaseFirestoreInterface>()
        .addDonationCount(donorID, donation!.portions);
    donation!.claimed();
  }

  // UI -------------------------------------------------------------------
  String getStatusText(bool isDonor) {
    switch (status) {
      case PING_CHARITY_WAITING:
      case POST_WAITING:
        return'Waiting for ${isDonor ? 'your' : 'their'} response';
      case PING_DONOR_DECLINED:
      case POST_DECLINED:
        return isDonor ? 'You declined the request' : 'Request was declined';
      case PING_ACCEPTED:
      case POST_ACCEPTED:
        return 'Waiting for charity to claim donation';
      case PING_DONOR_WAITING:
        return 'Waiting for ${isDonor ? 'their' : 'your'} response';
      case PING_CHARITY_DECLINED:
        return isDonor ? 'Donation was declined' : 'You declined their donation';
      case PING_CLAIMED:
      case POST_CLAIMED:
        return 'Donation claimed';
      default:
        return 'Unknown';
    }
  }

  Widget showStatus({bool isDonor = true}) { 
    return ListTile(
      title: Text(
        getStatusText(isDonor),
        style: TextStyle(
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget showTimeCreated() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.send_sharp),
        title: Text('Sent at'),
        subtitle: Text(
          formatDateTime(timeCreated, format: 'd/MM/yy hh:mm aa'),
        ),
      ),
    );
  }

  Widget? getIconFromStatus() {
    switch (status) {
      case PING_DONOR_WAITING:
        return Icon(
          Icons.pending_actions_outlined,
          color: Colors.blue,
          size: 40,
        );
      case PING_CHARITY_WAITING:
      case POST_WAITING:
        return Icon(
          Icons.pending_actions_outlined,
          color: Colors.orange,
          size: 40,
        );
      case PING_ACCEPTED:
      case POST_ACCEPTED:
        return Icon(
          Icons.gpp_good_outlined,
          color: Colors.orange,
          size: 40,
        );
      case PING_CLAIMED:
      case POST_CLAIMED:
        return Icon(
          Icons.gpp_good_outlined,
          color: Colors.green,
          size: 40,
        );
      case PING_DONOR_DECLINED:
      case PING_CHARITY_DECLINED:
      case POST_DECLINED:
        return Icon(
          Icons.cancel_outlined,
          color: Colors.red,
          size: 40,
        );
    }
  }
}
