// Page displaying all claim requests made

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/charity/charity_drawer.dart';
import 'package:drp_basket_app/views/charity/utilities/utilities.dart';
import 'package:drp_basket_app/views/donor/donations/donor_donation_form.dart';
import 'package:drp_basket_app/views/donor/donor.dart';
import 'package:flutter/material.dart';

import 'claim_request_form.dart';
import 'claim_request_page.dart';

class ClaimRequests extends StatefulWidget {
  const ClaimRequests({Key? key}) : super(key: key);

  @override
  _ClaimRequestsState createState() => _ClaimRequestsState();
}

class _ClaimRequestsState extends State<ClaimRequests> {
  final store = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var claimReqs = store
        .collection('charities')
        .doc('wy-test-charity') //TODO change to cur charityID
        .collection('requests')
        .snapshots();
    return Container(
      child: StreamBuilder(
        stream: claimReqs,
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Utilities.loading();
          }
          var claimRequests = snapshot.data!.docs;
          return claimRequests.isEmpty
              ? Center(
                  child: Text('No Requests Made'),
                )
              : ListView(
                  children: claimRequests.map(
                    (DocumentSnapshot ds) {
                      var reqID = ds.reference.id;
                      var reqMap = ds.data() as Map<String, dynamic>;
                      return _buildRequestTile(reqID, reqMap);
                    },
                  ).toList(),
                );
        },
      ),
    );
  }

  Widget _buildRequestTile(String requestID, Map<String, dynamic> requestMap) {
    var donationID = requestMap['donation_id'];
    var donationStream =
        store.collection('donations').doc(donationID).snapshots();
    return StreamBuilder(
      stream: donationStream,
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var donationMap = snapshot.data!.data() as Map<String, dynamic>;
        Donation donation = Donation.buildFromMap(donationID, donationMap);
        ClaimRequest req =
            ClaimRequest.buildFromMap(requestID, requestMap, donation);
        return _buildFromRequest(req);
      },
    );
  }

  Widget _buildFromRequest(ClaimRequest request) {
    var donorStream =
        store.collection('donors').doc(request.donation.donorID).snapshots();
    return StreamBuilder(
      stream: donorStream,
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var donorID = snapshot.data!.reference.id;
        var donorMap = snapshot.data!.data();
        Donor donor = Donor.buildFromMap(donorID, donorMap);
        return GestureDetector(
          child: Card(
            child: ListTile(
              leading: ClaimRequest.getIcon(request.status),
              title: Text(
                donor.name,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text('Status: ${request.status}'),
              trailing: Text(formatDateTime(request.timeCreated,
                  format: 'd/MM/yy hh:mm aa')),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ClaimRequestPage(request, donor),
                ));
          },
        );
      },
    );
  }

}
