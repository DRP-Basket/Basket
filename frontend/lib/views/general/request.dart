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
  String? message;
  bool? closed;

  Request(
      {required this.charityID,
      required this.donorID,
      this.donation,
      required this.timeCreated,
      required this.status,
      this.message,
      this.closed});

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
  static const PING_UNSUCCESSFUL = 'ping_unsuccessful';
  static const POST_CLAIMED = 'post_claimed';
  static const POST_UNSUCCESSFUL = 'post_unsuccessful';

  // Firestore field names
  static const CHARITY_ID = 'charity_id';
  static const DONOR_ID = 'donor_id';
  static const DONATION_ID = 'donation_id';
  static const STATUS = 'status';
  static const MESSAGE = 'message';
  static const TIME_CREATED = 'time_created';
  static const CLOSED = 'closed';

  static Request buildFromMap(
      {required String id,
      required Map<String, dynamic> req,
      Donation? donation}) {
    Request request = Request(
        charityID: req[CHARITY_ID],
        donorID: req[DONOR_ID],
        donation: donation,
        timeCreated: req[TIME_CREATED].toDate(),
        status: req[STATUS],
        message: req[MESSAGE],
        closed: req[CLOSED]);
    request.id = id;
    return request;
  }

  static Future<Request> sendRequest(
      {required String donorID, Donation? donation}) async {
    Request req = Request(
      charityID: curUser.uid,
      donorID: donorID,
      donation: donation,
      timeCreated: DateTime.now(),
      status: donation == null ? PING_CHARITY_WAITING : POST_WAITING,
    );
    await req.fsSendRequest();
    return req;
  }

  Widget getMessage() {
    return ListTile(
      title: Text(
        "Message",
      ),
      subtitle: Text(
        message != null ? message! : "N/A",
      ),
    );
  }

  Future<void> fsSendRequest() async {
    // Save request in charity's requests collection
    await _store
        .collection('charities')
        .doc(charityID)
        .collection('request_list')
        .add({
      CHARITY_ID: charityID,
      DONOR_ID: donorID,
      DONATION_ID: donation?.id,
      TIME_CREATED: timeCreated,
      STATUS: status,
      CLOSED: false,
    }).then((requestRef) async {
      // Save newly created request id
      id = requestRef.id;
      // Add to donor's side
      await _store
          .collection('donors')
          .doc(donorID)
          .collection('request_list')
          .doc(id)
          .set({
        CHARITY_ID: charityID,
        TIME_CREATED: timeCreated,
        CLOSED: false,
      });
      // Add to donation's list if present
      if (donation != null) {
        await addRequestToDonation(donation!);
      }
    });
  }

  Future<void> fsUpdate(Map<String, dynamic> fields) async {
    await _store
        .collection('charities')
        .doc(charityID)
        .collection('request_list')
        .doc(id)
        .update(fields);
  }

  Future<void> addRequestToDonation(Donation donation) async {
    await _store
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
  Future<void> respond(Donation donation) async {
    assert(status == PING_CHARITY_WAITING);
    await fsUpdate({
      DONATION_ID: donation.id,
      STATUS: PING_DONOR_WAITING,
    });
    await addRequestToDonation(donation);
  }

  Future<void> donorDecline({String? message}) async {
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
    await fsUpdate({
      STATUS: newStatus,
      MESSAGE: message,
      CLOSED: true,
    });
    await donorClose();
  }

  Future<void> donorAccept() async {
    assert(status == POST_WAITING);
    await fsUpdate({
      STATUS: POST_ACCEPTED,
    });
    await donation!.assignToCharity(charityID);
  }

  Future<void> donorClose() async {
    await _store
        .collection('donors')
        .doc(donorID)
        .collection('request_list')
        .doc(id)
        .update({
      CLOSED: true,
    });
  }

  // Charity Actions ------------------------------------------------------

  Future<void> charityAccept() async {
    assert(status == PING_DONOR_WAITING);
    await fsUpdate({
      STATUS: PING_ACCEPTED,
    });
  }

  Future<void> charityDecline() async {
    assert(status == PING_DONOR_WAITING);
    await fsUpdate({
      STATUS: PING_CHARITY_DECLINED,
    });
    // TODO : canceled status
  }

  Future<void> claimed() async {
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
    await fsUpdate({
      STATUS: newStatus,
    });
    await donation!.claimed();
    locator<FirebaseFirestoreInterface>()
        .addDonationCount(donorID, donation!.portions);
  }

  Future<void> unsuccessfulClaim() async {
    String newStatus = '';
    switch (status) {
      case POST_ACCEPTED:
        newStatus = POST_UNSUCCESSFUL;
        break;
      case PING_ACCEPTED:
        newStatus = PING_UNSUCCESSFUL;
        break;
      default:
        assert(false);
    }
    await fsUpdate({
      STATUS: newStatus,
    });
    await donation!.unsuccessful();
  }

  Future<void> charityClose() async {
    await fsUpdate({
      CLOSED: true,
    });
  }

  // UI -------------------------------------------------------------------
  bool endState() {
    switch (status) {
      case PING_DONOR_DECLINED:
      case POST_DECLINED:
      case PING_CHARITY_DECLINED:
      case PING_CLAIMED:
      case POST_CLAIMED:
      case PING_UNSUCCESSFUL:
      case POST_UNSUCCESSFUL:
        return true;
      default:
        return false;
    }
  }

  String getStatusText(bool isDonor) {
    switch (status) {
      case PING_CHARITY_WAITING:
      case POST_WAITING:
        return 'Waiting for ${isDonor ? 'your' : 'their'} response';
      case PING_DONOR_DECLINED:
      case POST_DECLINED:
        return isDonor ? 'You declined the request' : 'Request was declined';
      case PING_ACCEPTED:
      case POST_ACCEPTED:
        return 'Waiting to claim donation';
      case PING_DONOR_WAITING:
        return 'Waiting for ${isDonor ? 'their' : 'your'} response';
      case PING_CHARITY_DECLINED:
        return isDonor
            ? 'Donation was declined'
            : 'You declined their donation';
      case PING_CLAIMED:
      case POST_CLAIMED:
        return 'Donation claimed';
      case POST_UNSUCCESSFUL:
      case PING_UNSUCCESSFUL:
        return 'Unsuccesful request';
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
        leading: Icon(
          Icons.send_sharp,
          color: Colors.amber,
        ),
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
      case PING_UNSUCCESSFUL:
      case POST_UNSUCCESSFUL:
        return Icon(
          Icons.cancel_outlined,
          color: Colors.red,
          size: 40,
        );
    }
  }
}
