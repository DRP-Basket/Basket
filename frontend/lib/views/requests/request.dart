import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donations/donation.dart';

import '../../locator.dart';

class Request {
  late final String id;
  final String charityID;
  final String donorID;
  final Donation? donation;
  final DateTime timeCreated;
  final String status;

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
  static const PING_WAITING = 'ping_waiting';
  static const POST_WAITING = 'post_waiting';

  // Firestore field names
  static const CHARITY_ID = 'charity_id';
  static const DONOR_ID = 'donor_id';
  static const DONATION_ID = 'donation_id';
  static const STATUS = 'status';
  static const TIME_CREATED = 'time_created';

  static Request sendRequest({required String donorID, Donation? donation}) {
    Request req = Request(
      charityID: curUser.uid,
      donorID: donorID,
      donation: donation,
      timeCreated: DateTime.now(),
      status: donation == null ? PING_WAITING : POST_WAITING,
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
        _store
            .collection('donors')
            .doc(donorID)
            .collection('donation_list')
            .doc(donation!.id)
            .collection('requests')
            .doc(id)
            .set({
          CHARITY_ID: charityID,
          TIME_CREATED: timeCreated,
        });
      }
    });
  }

  void respond(Donation? donation) {
    // TODO
  }
}
