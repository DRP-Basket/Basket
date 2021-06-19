import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class Donation {
  late String id;
  String donorID;
  String status;
  String items;
  int portions;
  DateTime timeCreated;
  String? assignedCharityID;
  String? options;
  String? collectTime;
  String? collectDate;

  static var curUser = locator<UserController>().curUser()!;
  var _store = FirebaseFirestore.instance;

  Donation(
      {required this.donorID,
      required this.status,
      required this.items,
      required this.portions,
      required this.timeCreated,
      this.assignedCharityID,
      this.options,
      this.collectDate,
      this.collectTime});

  static Future<Donation> addNewDonation (
      {required String items,
      required int portions,
      String? options,
      String? collectDate,
      String? collectTime,
      String? charityID}) async {
    // Initialise fields
    Donation donation = Donation(
      donorID: curUser.uid,
      status: charityID == null ? 'Available' : 'Assigned',
      items: items,
      portions: portions,
      timeCreated: DateTime.now(),
      options: options,
      collectDate: collectDate,
      collectTime: collectTime,
      assignedCharityID: charityID,
    );
    // Add to firestore
    await donation.fsAddDonation();
    return donation;
  }

  static const DONOR_ID = 'donor_id';
  static const STATUS = 'status';
  static const ITEMS = 'items';
  static const PORTIONS = 'portions';
  static const TIME_CREATED = 'time_created';
  static const OPTIONS = 'options';
  static const COLLECT_DATE = 'collect_date';
  static const COLLECT_TIME = 'collect_time';
  static const CHARITY_ID = 'charity_id';

  Future<void> fsAddDonation() async {
    // Save donation in donor's donations collection
    await _store.collection('donors').doc(donorID).collection('donation_list').add({
      'donor_id': donorID,
      'status': status,
      'items': items,
      'portions': portions,
      'time_created': timeCreated,
      'options': options,
      'collect_date': collectDate,
      'collect_time': collectTime,
      'charity_id': assignedCharityID,
    }).then((donationRef) {
      // Save newly created donation id
      id = donationRef.id;
      // Add to general list for posting if available
      if (status == 'Available') {
        _store.collection('available_donations').doc(id).set({
          'donor_id': donorID,
          'time_created': timeCreated,
        });
      }
    });
  }

  void fsUpdate(Map<String, dynamic> fields) {
    _store
        .collection('donors')
        .doc(donorID)
        .collection('donation_list')
        .doc(id)
        .update(fields);
  }

  static Donation buildFromMap(
      String donationID, Map<String, dynamic> donation) {
    // Initialise fields
    Donation _donation = Donation(
      donorID: donation[DONOR_ID],
      status: donation[STATUS],
      items: donation[ITEMS],
      portions: donation[PORTIONS],
      timeCreated: donation[TIME_CREATED].toDate(),
      options: donation[OPTIONS],
      collectDate: donation[COLLECT_DATE],
      collectTime: donation[COLLECT_TIME],
      assignedCharityID: donation[CHARITY_ID],
    );
    _donation.id = donationID;
    return _donation;
  }

  Widget display({bool showCharity: true}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          displayField('Items', items),
          displayField('Portions', portions.toString()),
          displayField('Collect before',
              nullOrAlt(collectDate) + nullOrAlt(collectTime)),
          displayField('Options', options),
          (!showCharity || (assignedCharityID == null))
              ? Container()
              : getCharityName(),
        ],
      ),
    );
  }

  Widget charityDisplay() {
    return Card(
      child: Column(
        children: [
          displayField('Items', items),
          Divider(),
          displayField('Portions', portions.toString()),
          Divider(),
          displayField('Date', nullOrAlt(collectDate)),
          Divider(),
          displayField('Collect by', nullOrAlt(collectTime)),
          Divider(),
          displayField('Dietary options', options),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Time posted'),
            subtitle: Text(formatDateTime(timeCreated)),
          ),
        ],
      ),
    );
  }

  Widget displaySummary() {
    return Column(
      children: [
        Text('$portions portions'),
        Text('Collect by: ${nullOrAlt(collectDate)} ${nullOrAlt(collectTime)}'),
      ],
    );
  }

  var store = FirebaseFirestore.instance;

  Widget getCharityName() {
    return StreamBuilder(
      stream: store.collection('charities').doc(assignedCharityID).snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var charity = snapshot.data!.data() as Map<String, dynamic>;
        return displayField('Associated charity', charity['name']);
      },
    );
  }

  String nullOrAlt(String? s, {String alt: ''}) {
    return s == null ? alt : s;
  }

  Widget displayField(String label, String? content,
      {Icon? icon, bool card: false}) {
    if (content == null || content.isEmpty) {
      return Container();
    }
    return ListTile(
      leading: icon,
      title: Text(
        label,
      ),
      subtitle: Text(
        content,
      ),
    );
  }

  void claimed() {
    fsUpdate({
      STATUS: 'Claimed',
    });
  }

  void assignToCharity(String charityID) {
    fsUpdate({
      STATUS: 'Assigned',
      CHARITY_ID: charityID,
    });
    _store.collection('available_donations').doc(id).delete();
  }
}
