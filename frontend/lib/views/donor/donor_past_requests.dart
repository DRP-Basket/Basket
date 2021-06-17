import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/views/donor/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonorPastRequests extends StatelessWidget {
  final String uid;
  const DonorPastRequests(this.uid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Past Requests"),
      ),
      body: _getRequests(),
    );
  }

  Widget _getRequests() {
    Stream<QuerySnapshot> _requestsStream =
        locator<FirebaseFirestoreInterface>()
            .getCollection("donors")
            .doc(uid)
            .collection("requests")
            .snapshots();

    return StreamBuilder(
      stream: _requestsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        var response = snapshot.data!.docs;

        if (response.isEmpty) {
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

        response = response
            .where((x) =>
                (x["status"] == "successful" || x["status"] == "unsuccessful"))
            .toList();

        // Sort to display most recently completed request first
        response.sort((a, b) {
          Timestamp aTime = a.data()["completion_time"];
          Timestamp bTime = b.data()["completion_time"];
          return bTime.compareTo(aTime);
        });

        List<Map<String, dynamic>> requestData = [];
        List<Future> charityFutures = [];

        response.forEach((doc) {
          requestData.add(doc.data());
          charityFutures.add(_getCharityData(doc.data()["charity_uid"]));
        });

        return FutureBuilder(
          future: Future.wait(charityFutures),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            print(snapshot.data![0].data());
            List<Map<String, dynamic>> charityData = [];
            snapshot.data!.forEach((doc) {
              charityData.add(doc.data());
            });

            List<Widget> children = [];
            requestData.forEach((req) {
              children.add(_buildReqCard(context, req));
            });
            return ListView(children: children);
          },
        );
      },
    );
  }

  Widget _buildReqCard(BuildContext context, Map<String, dynamic> requestData) {
    print(requestData);
    String status = requestData["status"];
    Widget icon = _getIcon(status);

    Widget card = Card(
      child: ListTile(
        leading: icon,
        title: Text(
          (status == "successful" ? "Completed" : "Closed") +
              " at ${DonorRequestUtilities.getTimeString(requestData["completion_time"])}",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
    return _buildReqCardRedirect(context, requestData, card);
  }

  Widget _getIcon(String status) {
    if (status == "successful") {
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

  Widget _buildReqCardRedirect(
      BuildContext context, Map<String, dynamic> requestData, Widget card) {
    String status = requestData["status"];
    String displayStatus = status[0].toUpperCase() + status.substring(1);
    return GestureDetector(
      onTap: () => {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("$displayStatus Donation"),
                  content: _getHistoryDialogContent(status, requestData),
                ))
      },
      child: card,
    );
  }

  Widget _getHistoryDialogContent(
      String status, Map<String, dynamic> requestData) {
    List<Widget> children = [
      _thirdColorText(
          "Sent at ${DonorRequestUtilities.getTimeString(requestData["create_time"])}"),
    ];
    if (status == "unsuccessful") {
      children.add(_thirdColorText(
          "Closed at ${DonorRequestUtilities.getTimeString(requestData["completion_time"])}"));
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
          "Completed at ${DonorRequestUtilities.getTimeString(requestData["completion_time"])}"));
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

  Future<DocumentSnapshot> _getCharityData(String uid) async {
    return locator<FirebaseFirestoreInterface>()
        .getCollection("charities")
        .doc(uid)
        .get();
  }
}
