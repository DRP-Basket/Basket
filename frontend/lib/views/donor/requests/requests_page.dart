import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/general/donation.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import 'request_page.dart';

// Page displaying all requests sent to donor

class RequestsPage extends StatefulWidget {
  final bool ongoing;

  const RequestsPage({Key? key, bool this.ongoing: true}) : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState(ongoing);
}

class _RequestsPageState extends State<RequestsPage> {
  final bool ongoing;

  static var curUser = locator<UserController>().curUser()!;
  var _store = FirebaseFirestore.instance;

  _RequestsPageState(this.ongoing);

  @override
  Widget build(BuildContext context) {
    var reqStream = _store
        .collection('donors')
        .doc(curUser.uid)
        .collection('request_list')
        .where(Request.CLOSED, isEqualTo: !ongoing)
        .orderBy(Request.TIME_CREATED)
        .snapshots();

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
                style: TextStyle(
                  color: third_color,
                  fontSize: 24,
                ),
              ),
            );
          }
          var reqs = snapshot.data!.docs;
          reqs.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            Timestamp aDate = aData["time_created"];
            Timestamp bDate = bData["time_created"];
            return bDate.compareTo(aDate);
          });
          return ListView(
            children: reqs.map(
              (DocumentSnapshot ds) {
                var reqID = ds.reference.id;
                var req = ds.data() as Map<String, dynamic>;
                return _requestTile(reqID, req[Request.CHARITY_ID]);
              },
            ).toList(),
          );
        });
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
        Request req = Request.buildFromMap(id: reqID, req: reqMap);
        return StreamBuilder(
          stream: _store.collection('charities').doc(charityID).snapshots(),
          builder:
              (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            var charity = snapshot.data!.data() as Map<String, dynamic>;
            Widget tileContent = Card(
              elevation: 5,
              shadowColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Colors.grey),
              ),
              child: ListTile(
                leading: req.getIconFromStatus(),
                title: Padding(
                  padding: EdgeInsets.only(
                    bottom: 5,
                  ),
                  child: Text(
                    charity['name'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Sent at ${formatDateTime(req.timeCreated, format: 'hh:mmaa d/MM/yy')}"),
                    Text(
                      req.getStatusText(true),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.more_horiz_outlined,
                ),
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
