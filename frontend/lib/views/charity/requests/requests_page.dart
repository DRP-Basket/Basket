import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/requests/request_page.dart';
import 'package:drp_basket_app/views/general/donation.dart';
import 'package:drp_basket_app/views/general/donor.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';

// Page displaying all requests the charity makes (onTap goes to `request_page`)

class RequestsPage extends StatefulWidget {
  final bool ongoing;
  final String? donorID;
  RequestsPage({Key? key, bool this.ongoing: true, String? this.donorID})
      : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState(ongoing, donorID);
}

class _RequestsPageState extends State<RequestsPage> {
  final bool ongoing;
  final String? donorID;

  static var curUser = locator<UserController>().curUser()!;
  var _store = FirebaseFirestore.instance;

  _RequestsPageState(this.ongoing, this.donorID);

  @override
  Widget build(BuildContext context) {
    var allReq = _store
        .collection('charities')
        .doc(curUser.uid)
        .collection('request_list');
    var filtered = donorID == null
        ? allReq.where(Request.CLOSED, isEqualTo: !ongoing)
        : allReq.where(Request.DONOR_ID, isEqualTo: donorID);
    var reqStream =
        filtered.orderBy(Request.TIME_CREATED, descending: true).snapshots();

    return StreamBuilder(
      stream: reqStream,
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No ${ongoing ? 'Ongoing' : 'Past'} Requests',
            ),
          );
        }
        var reqs = snapshot.data!.docs;
        return ListView(
          // Build each request to diplay as tile
          children: reqs.map(
            (DocumentSnapshot ds) {
              var reqID = ds.reference.id;
              var reqMap = ds.data() as Map<String, dynamic>;
              return _buildRequestTile(reqID, reqMap);
            },
          ).toList(),
        );
      },
    );
  }

  Widget _buildRequestTile(String requestID, Map<String, dynamic> requestMap) {
    // Collect request information
    Request req = Request.buildFromMap(id: requestID, req: requestMap);
    var donorStream = _store.collection('donors').doc(req.donorID).snapshots();
    return StreamBuilder(
      stream: donorStream,
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        // Collect donor information
        var donorMap = snapshot.data!.data() as Map<String, dynamic>;
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
        // Collect donation information if available
        return StreamBuilder(
          stream: _store
              .collection('donors')
              .doc(req.donorID)
              .collection('donation_list')
              .doc(requestMap[Request.DONATION_ID])
              .snapshots(),
          builder:
              (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return Container();
            var donMap = snapshot.data!.data() as Map<String, dynamic>;
            Donation don =
                Donation.buildFromMap(requestMap[Request.DONATION_ID], donMap);
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
