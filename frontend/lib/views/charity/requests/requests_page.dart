import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/requests/request_page.dart';
import 'package:drp_basket_app/views/donations/donation.dart';
import 'package:drp_basket_app/views/donor/donor.dart';
import 'package:drp_basket_app/views/requests/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  static var curUser = locator<UserController>().curUser()!;
  var _store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var reqStream = _store
        .collection('charities')
        .doc(curUser.uid)
        .collection('request_list')
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('My Requests'),),
      body: StreamBuilder(
        stream: reqStream,
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          var reqs = snapshot.data!.docs;
          return reqs.isEmpty
              ? Center(
                  child: Text('No Requests Made'),
                )
              : ListView(
                  children: reqs.map(
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
    Request req = Request.buildFromMap(requestID, requestMap, null);
    var donorStream = _store.collection('donors').doc(req.donorID).snapshots();
    return StreamBuilder(
      stream: donorStream,
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var donorMap = snapshot.data!.data();
        Donor donor = Donor.buildFromMap(req.donorID, donorMap);
        Widget tileContent = Card(
          child: ListTile(
            leading: req.getIconFromStatus(),
            title: Text(
              donor.name,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              req.getStatusText(false),
            ),
            trailing: Text(
                formatDateTime(req.timeCreated, format: 'd/MM/yy hh:mm aa')),
          ),
        );
        if (requestMap[Request.DONATION_ID] == null) {
          return _make(tileContent, req, donor);
        }
        return StreamBuilder(
          stream: _store.collection('donors').doc(req.donorID).collection('donation_list').doc(requestMap[Request.DONATION_ID]).snapshots(),
          builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return Container();
            var donMap = snapshot.data!.data() as Map<String, dynamic>;
            Donation don = Donation.buildFromMap(requestMap[Request.DONATION_ID], donMap);
            req.donation = don;
            return _make(tileContent, req, donor);
          },
        );
      },
    );
  }

  Widget _make(Widget child, Request request, Donor donor) {
    return GestureDetector(
      child: child,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => RequestPage(request, donor),
            ));
      },
    );
  }
}
