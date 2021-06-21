import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/general/donation.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../../../locator.dart';
import '../requests/request_page.dart';

// Displays all donations made

class DonorDonationsPage extends StatefulWidget {
  const DonorDonationsPage({Key? key}) : super(key: key);

  @override
  _DonorDonationsPageState createState() => _DonorDonationsPageState();
}

class _DonorDonationsPageState extends State<DonorDonationsPage> {
  static var curUser = locator<UserController>().curUser()!;
  var _store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _store
          .collection('donors')
          .doc(curUser.uid)
          .collection('donation_list')
          .orderBy('time_created', descending: true)
          .snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Donations Posted Yet',
              style: TextStyle(
                color: third_color,
                fontSize: 24,
              ),
            ),
          );
        }
        var donations = snapshot.data!.docs;
        return ListView(
          children: donations.map(
            (DocumentSnapshot ds) {
              var donationID = ds.reference.id;
              var donationMap = ds.data() as Map<String, dynamic>;
              var donation =
                  Donation.buildFromMap(donationID, donationMap); // TODO
              return _displayDonation(donation);
            },
          ).toList(),
        );
      },
    );
  }

  Widget _displayDonation(Donation donation) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpandablePanel(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  formatDateTime(donation.timeCreated,
                      format: 'd/MM/yy hh:mmaa'),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Status'),
                subtitle: Text(
                  donation.status,
                  style: _getStatusStyle(donation.status),
                ),
              ),
            ],
          ),
          collapsed: Container(),
          expanded: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(
                  thickness: 1,
                ),
                _getTabBars(),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.375,
                    child: TabBarView(
                      children: [
                        donation.display(),
                        _claimRequests(donation),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTabBars() {
    return Container(
      child: TabBar(
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.blue[300],
        tabs: [
          Tab(
            icon: Icon(
              Icons.info_sharp,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.mail_sharp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _claimRequests(Donation donation) {
    var reqStream = _store
        .collection('donors')
        .doc(curUser.uid)
        .collection('donation_list')
        .doc(donation.id)
        .collection('requests')
        .snapshots();
    return StreamBuilder(
      stream: reqStream,
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var reqs = snapshot.data!.docs;
        return ListView(
          children: reqs.map(
            (DocumentSnapshot ds) {
              var req = ds.data() as Map<String, dynamic>;
              var charityID = req['charity_id'];
              return _requestTile(ds.reference.id, donation, charityID);
            },
          ).toList(),
        );
      },
    );
  }

  Widget _requestTile(String reqID, Donation donation, String charityID) {
    var charityStream =
        _store.collection('charities').doc(charityID).snapshots();
    return StreamBuilder(
      stream: charityStream,
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var charity = snapshot.data!.data() as Map<String, dynamic>;
        var requestStream = _store
            .collection('charities')
            .doc(charityID)
            .collection('request_list')
            .doc(reqID)
            .snapshots();
        return StreamBuilder(
          stream: requestStream,
          builder:
              (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            var reqMap = snapshot.data!.data() as Map<String, dynamic>;
            Request req = Request.buildFromMap(
                id: reqID, req: reqMap, donation: donation);
            return GestureDetector(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      leading: req.getIconFromStatus(),
                      title: Text(
                        charity['name'],
                        style: TextStyle(
                          fontSize: 18,
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
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => RequestPage(req, charity)));
              },
            );
          },
        );
      },
    );
  }

  TextStyle? _getStatusStyle(String status) {
    Color? color;
    if (status == "Available") {
      color = secondary_color;
    } else if (status == "Assigned") {
      color = Colors.amber;
    } else if (status == "Claimed") {
      color = Colors.grey;
    }
    return color == null ? null : TextStyle(color: color);
  }
}
