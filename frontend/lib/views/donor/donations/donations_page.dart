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
        List<Widget> children = donations.map(
          (DocumentSnapshot ds) {
            var donationID = ds.reference.id;
            var donationMap = ds.data() as Map<String, dynamic>;
            var donation =
                Donation.buildFromMap(donationID, donationMap); // TODO
            return _displayDonation(donation);
          },
        ).toList();
        return ListView(
          children: children,
        );
      },
    );
  }

  Widget _displayDonation(Donation donation) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpandablePanel(
          header: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              donation.timeCreated.toString(),
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          collapsed: ListTile(
            title: Text('Status'),
            subtitle: Text(donation.status),
          ),
          expanded: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                ListTile(
                  title: Text('Status: ${donation.status}'),
                ),
                Divider(),
                _getTabBars(),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: TabBarView(
                    children: [
                      donation.display(),
                      _claimRequests(donation),
                    ],
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
        tabs: [
          Tab(
            icon: Icon(
              Icons.info_sharp,
              color: Colors.grey,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.mail_sharp,
              color: Colors.grey,
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
                  ListTile(
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
                    trailing: Text(
                      formatDateTime(req.timeCreated,
                          format: 'd/MM/yy hh:mm aa'),
                    ),
                  ),
                  Divider(),
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
}
