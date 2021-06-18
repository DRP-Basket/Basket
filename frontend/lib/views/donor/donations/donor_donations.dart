import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/charity/donations/claim_request_form.dart';
import 'package:drp_basket_app/views/charity/utilities/utilities.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'claim_request_page.dart';
import 'donor_donation_form.dart';

class DonorDonations extends StatelessWidget {
  const DonorDonations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Donations'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Donate",
                ),
                Tab(
                  text: "History",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DonorDonationForm(),
              DonorDonationsPage(),
            ],
          )),
    );
  }
}

class DonorDonationsPage extends StatefulWidget {
  const DonorDonationsPage({Key? key}) : super(key: key);

  @override
  _DonorDonationsPageState createState() => _DonorDonationsPageState();
}

class _DonorDonationsPageState extends State<DonorDonationsPage> {
  var _store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _store
          .collection('donors')
          .doc('wy-test-donor')
          .collection('donations')
          .orderBy('time_created', descending: true)
          .snapshots(), // TODO change to current donor,
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Utilities.loading();
        }
        var donations = snapshot.data!.docs;
        return ListView(
          children: donations.map((DocumentSnapshot ds) {
            return StreamBuilder(
                stream: _store
                    .collection('donations')
                    .doc(ds.reference.id)
                    .snapshots(),
                builder: (BuildContext ctx,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  var donationMap =
                      snapshot.data!.data() as Map<String, dynamic>;
                  var donation =
                      Donation.buildFromMap(ds.reference.id, donationMap);
                  return Card(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: _displayDonation(donation),
                    ),
                  );
                });
          }).toList(),
        );
      },
    );
  }

  Widget _displayDonation(Donation donation) {
    return ExpandablePanel(
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
        trailing: donation.hasPendingRequest() ? Icon(Icons.mail_sharp) : null,
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
                  _donationInfo(donation),
                  _claimRequests(donation),
                ],
              ),
            ),
          ],
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

  Widget _donationInfo(Donation donation) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text('Description'),
            subtitle: Text(
                donation.description == null ? '-' : donation.description!),
          ),
          ListTile(
            title: Text('Collect by'),
            subtitle: Text(formatDateTime(donation.collectBy)),
          ),
        ],
      ),
    );
  }

  Widget _claimRequests(Donation donation) {
    var reqStream = _store
        .collection('donations')
        .doc(donation.donationID)
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
              var map = ds.data() as Map<String, dynamic>;
              var charityID = map['charity_id'];
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
            .collection('requests')
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
            ClaimRequest req =
                ClaimRequest.buildFromMap(reqID, reqMap, donation);
            return GestureDetector(
              child: Column(
                children: [
                  ListTile(
                    leading: ClaimRequest.getIcon(req.status),
                    title: Text(
                      charity['name'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Status: ${req.status}',
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
                        builder: (ctx) => DonorClaimRequestPage(req, charity)));
              },
            );
          },
        );
      },
    );
  }
}
