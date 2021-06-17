import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/views/charity/charity_donor.dart';
import 'package:drp_basket_app/views/charity/donor_request_end.dart';
import 'package:drp_basket_app/views/charity/utilities.dart';
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
            DonorPageUtilities.introRow(donorModel),
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
                  _getRequests(false),
                  _getRequests(true),
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

  Widget _getRequests(bool past) {
    final Stream<DocumentSnapshot> _requestsStream =
        locator<FirebaseFirestoreInterface>()
            .getCollection("charities")
            .doc("ex-charity")
            .collection("donors")
            .doc(donorModel.uid)
            .snapshots();
    String query = past ? "past_requests" : "ongoing_requests";

    return StreamBuilder(
      stream: _requestsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.data.data()[query] == null) {
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
        snapshot.data.data()[query].forEach((id) {
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
                    fontSize: 24,
                  ),
                ),
              );
            }
            List<Widget> children = [];
            reqIDs = [];
            String sortValue = past ? "completion_time" : "create_time";
            snapshot.data!.sort((a, b) {
              Timestamp aTime = a.data()[sortValue];
              Timestamp bTime = b.data()[sortValue];
              return bTime.compareTo(aTime);
            });
            snapshot.data!.forEach((req) {
              reqIDs.add(req.id);
              children.add(_buildReqCard(req.id, req.data(), past));
            });
            // Prevent send request before reqIDs initialised
            canSendReq = true;
            if (reqIDs.isEmpty) {
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
            return ListView(children: children);
          },
        );
      },
    );
  }

  Widget _buildReqCard(
      dynamic reqID, Map<String, dynamic> requestData, bool past) {
    String status = requestData["status"];
    Widget icon = _getIcon(status);

    Widget card = Card(
      child: ListTile(
        leading: icon,
        title: Text(
          _getTitle(status, requestData),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          _getSubtitle(status, requestData),
        ),
      ),
    );
    return _buildReqCardRedirect(status, reqID, requestData, card);
  }

  Widget _getIcon(String status) {
    if (status == "pending") {
      return Icon(
        Icons.pending_actions_outlined,
        color: Colors.orange,
        size: 40,
      );
    } else if (status == "confirmed") {
      return Icon(
        Icons.gpp_good_outlined,
        color: Colors.green,
        size: 40,
      );
    } else if (status == "successful") {
      return Icon(
        Icons.tag_faces_outlined,
        color: Colors.green,
        size: 40,
      );
    } else {
      //Unsuccessful
      return Icon(
        Icons.cancel_outlined,
        color: Colors.red,
        size: 40,
      );
    }
  }

  String _getTitle(String status, Map<String, dynamic> requestData) {
    String mapValue = (status == "pending" || status == "confirmed")
        ? "create_time"
        : "completion_time";
    String prefix = (status == "pending" || status == "confirmed")
        ? "Sent"
        : (status == "successful" ? "Completed" : "Cancelled");

    return prefix +
        " at ${DonorPageUtilities.getTimeString(requestData[mapValue])}";
  }

  String _getSubtitle(String status, Map<String, dynamic> requestData) {
    if (status == "confirmed") {
      return 'Collect by ${requestData["collect_time"]} on ${requestData["collect_date"]}';
    } else if (status == "pending") {
      return "No response yet";
    } else {
      return "";
    }
  }

  Widget _buildReqCardRedirect(String status, dynamic reqID,
      Map<String, dynamic> requestData, Widget card) {
    if (status == "confirmed") {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DonorRequestEnd(donorModel, reqID, requestData),
            ),
          )
        },
        child: card,
      );
    } else if (status == "successful" || status == "unsuccessful") {
      String displayStatus = status[0].toUpperCase() + status.substring(1);
      return GestureDetector(
        onTap: () => {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("$displayStatus request"),
                    content: _getHistoryDialogContent(status, requestData),
                  ))
        },
        child: card,
      );
    } else {
      // pending
      return card;
    }
  }

  Widget _getHistoryDialogContent(
      String status, Map<String, dynamic> requestData) {
    List<Widget> children = [
      _thirdColorText(
          "Sent at ${DonorPageUtilities.getTimeString(requestData["create_time"])}"),
    ];
    if (status == "unsuccessful") {
      children.add(_thirdColorText(
          "Closed at ${DonorPageUtilities.getTimeString(requestData["completion_time"])}"));
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Message",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
      if (requestData["message"] != null) {
        children.add(_thirdColorText(requestData["message"]));
      } else {
        children.add(_thirdColorText("N/A"));
      }
    } else {
      // successful
      children.add(_thirdColorText(
          "Completed at ${DonorPageUtilities.getTimeString(requestData["completion_time"])}"));
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Donation Information",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
      children.add(_thirdColorText(requestData["items"]));
      children.add(_thirdColorText(requestData["portions"] + " portions"));
      children.add(_thirdColorText(requestData["options"]));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _thirdColorText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: third_color,
      ),
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
        .update({"ongoing_requests": reqIDs});
  }
}
