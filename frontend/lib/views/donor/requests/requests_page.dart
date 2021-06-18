import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donations/donation.dart';
import 'package:drp_basket_app/views/requests/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import 'request_page.dart';

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
        .collection('donors')
        .doc(curUser.uid)
        .collection('request_list')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Charity Requests'),
      ),
      body: StreamBuilder(
          stream: reqStream,
          builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loading();
            }
            var reqs = snapshot.data!.docs;
            return ListView(
              children: reqs.map(
                (DocumentSnapshot ds) {
                  var reqID = ds.reference.id;
                  var req = ds.data() as Map<String, dynamic>;
                  return _requestTile(reqID, req[Request.CHARITY_ID]);
                },
              ).toList(),
            );
          }),
    );
  }

  Widget _requestTile(String reqID, String charityID) {
    var reqStream = _store
        .collection('charities')
        .doc(charityID)
        .collection('request_list')
        .doc(reqID)
        .snapshots();
    return StreamBuilder(
      stream: reqStream,
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var reqMap = snapshot.data!.data() as Map<String, dynamic>;
        Request req = Request.buildFromMap(reqID, reqMap, null);
        return StreamBuilder(
          stream: _store.collection('charities').doc(charityID).snapshots(),
          builder:
              (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            var charity = snapshot.data!.data() as Map<String, dynamic>;
            Widget tileContent = Card(
              child: ListTile(
                leading: req.getIconFromStatus(),
                title: Text(
                  charity['name'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  req.getStatusText(true),
                ),
                trailing: Text(formatDateTime(req.timeCreated,
                    format: 'd/MM/yy hh:mm aa')),
              ),
            );
            if (reqMap[Request.DONATION_ID] == null) {
              return _make(tileContent, req, charity);
            }
            return StreamBuilder(
              stream: _store
                  .collection('donors')
                  .doc(req.donorID)
                  .collection('donation_list')
                  .doc(reqMap[Request.DONATION_ID])
                  .snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) return Container();
                var donMap = snapshot.data!.data() as Map<String, dynamic>;
                Donation don =
                    Donation.buildFromMap(reqMap[Request.DONATION_ID], donMap);
                req.donation = don;
                return _make(tileContent, req, charity);
              },
            );
          },
        );
      },
    );
  }

  Widget _make(Widget child, Request request, Map<String, dynamic> charity) {
    return GestureDetector(
      child: child,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => RequestPage(request, charity),
            ));
      },
    );
  }
}
