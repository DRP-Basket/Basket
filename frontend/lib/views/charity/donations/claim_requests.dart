// Page displaying all claim requests made

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/charity/charity_drawer.dart';
import 'package:drp_basket_app/views/charity/utilities/utilities.dart';
import 'package:flutter/material.dart';

import 'claim_request_form.dart';

class ClaimRequests extends StatefulWidget {
  const ClaimRequests({Key? key}) : super(key: key);

  @override
  _ClaimRequestsState createState() => _ClaimRequestsState();
}

class _ClaimRequestsState extends State<ClaimRequests> {
  @override
  Widget build(BuildContext context) {
    var store = FirebaseFirestore.instance;
    var claimReqs = store
        .collection('charities')
        .doc('wy-test-charity') //TODO change to cur charityID
        .collection('requests')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim Requests'),
      ),
      drawer: CharityDrawer(),
      body: StreamBuilder(
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
                  children: claimRequests.map((DocumentSnapshot ds) {
                    var claimRequest = ClaimRequest.buildFromMap(
                        ds.reference.id, ds.data() as Map<String, dynamic>);
                    return GestureDetector(
                      child: Card(
                        child: ListTile(
                          leading: _getIcon(claimRequest.status),
                          title: _getDonorName(claimRequest.donationID),
                          subtitle: Row(
                            children: [
                              Text('Status: ${claimRequest.status}'),
                              Text(formatDateTime(claimRequest.timeCreated)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
        },
      ),
    );
  }

  Widget _getDonorName(donationID) {
    return Text('TODO: get donor name');
  }

  Widget _getIcon(status) {
    return Text('TODO: ICON');
  }
}
