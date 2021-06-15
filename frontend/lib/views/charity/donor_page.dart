import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/views/charity/charity_donor.dart';
import 'package:drp_basket_app/views/charity/donor_request_end.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({Key? key}) : super(key: key);

  @override
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late DonorModel donorModel;
  late List<dynamic> reqIDs;
  bool canSendReq = false;

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    donorModel = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(donorModel.name),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 30,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: CircleAvatar(
                        backgroundImage: donorModel.image,
                        radius: 75,
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 35,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          donorModel.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            '${donorModel.address}',
                            style: TextStyle(
                              color: third_color,
                            ),
                          ),
                        ),
                        Text(
                          '${donorModel.contactNumber}',
                          style: TextStyle(
                            color: third_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.25),
                  bottom: BorderSide(color: Colors.grey, width: 0.25),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: secondary_color,
                indicatorWeight: 3.5,
                labelColor: third_color,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: "Ongoing"),
                  Tab(text: "History"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _getRequests(),
                  Center(
                    child: Text('Location'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondary_color,
        onPressed: () {
          if (!canSendReq) {
            return;
          }
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Are you sure you want to send a donation request?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await _sendNewReq();
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
        label: Text("Send request"),
      ),
    );
  }

  Widget _getRequests() {
    final Stream<DocumentSnapshot> _requestsStream =
        locator<FirebaseFirestoreInterface>()
            .getCollection("charities")
            .doc("ex-charity")
            .collection("donors")
            .doc(donorModel.uid)
            .snapshots();

    return StreamBuilder(
      stream: _requestsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.data.data()["requests"] == null) {
          return Center(
            child: Text(
              "No requests",
              style: TextStyle(
                color: third_color,
                fontSize: 24,
              ),
            ),
          );
        }
        List<Future> futures = [];
        snapshot.data.data()["requests"].forEach((id) {
          futures.add(_getReqDetails(donorModel.uid, id));
        });
        return FutureBuilder(
          future: Future.wait(futures),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  "No requests",
                  style: TextStyle(
                    color: third_color,
                  ),
                ),
              );
            }
            List<Widget> children = [];
            reqIDs = [];
            snapshot.data!.sort((a, b) {
              Timestamp aTime = a.data()["create_time"];
              Timestamp bTime = b.data()["create_time"];
              return bTime.compareTo(aTime);
            });
            snapshot.data!.forEach((req) {
              reqIDs.add(req.id);
              children.add(_buildReqCard(req.data()));
            });
            // Prevent send request before reqIDs initialised
            canSendReq = true;
            return ListView(children: children);
          },
        );
      },
    );
  }

  Future<DocumentSnapshot> _getReqDetails(String donorUID, String reqID) {
    return locator<FirebaseFirestoreInterface>()
        .getCollection("donors")
        .doc(donorUID)
        .collection("requests")
        .doc(reqID)
        .get();
  }

  Widget _buildReqCard(Map<String, dynamic> requestData) {
    String status = requestData["status"];
    Widget icon;
    if (status == "pending") {
      icon = Icon(
        Icons.pending_actions_outlined,
        color: Colors.orange,
        size: 40,
      );
    } else {
      icon = Icon(
        Icons.gpp_good_outlined,
        color: Colors.green,
        size: 40,
      );
    }
    List<String> timeStrings = DateTime.fromMicrosecondsSinceEpoch(
            requestData["create_time"].microsecondsSinceEpoch)
        .toString()
        .split(':');
    Widget card = Card(
      child: ListTile(
        leading: icon,
        title: Text(
          'Sent at ${timeStrings[0]}:${timeStrings[1]}',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          status == "confirmed"
              ? 'Collect by ${requestData["collect_time"]} on ${requestData["collect_date"]}'
              : "No response yet",
        ),
      ),
    );
    if (status == "confirmed") {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider<Map<String, dynamic>>(
                create: (context) => requestData,
                child: DonorRequestEnd(),
              ),
            ),
          )
        },
        child: card,
      );
    } else {
      return card;
    }
  }

  Future<void> _sendNewReq() async {
    var newReq = await locator<FirebaseFirestoreInterface>()
        .getCollection("donors")
        .doc(donorModel.uid)
        .collection("requests")
        .add({
      "charity_uid": "egDsElPay1QgUDvSdnO7", //TODO: USE CHARITY ID
      "create_time": Timestamp.now(),
      "status": "pending"
    });
    reqIDs.add(newReq.id);
    await locator<FirebaseFirestoreInterface>()
        .getCollection("charities")
        .doc("ex-charity")
        .collection("donors")
        .doc(donorModel.uid)
        .update({"requests": reqIDs});
  }
}
