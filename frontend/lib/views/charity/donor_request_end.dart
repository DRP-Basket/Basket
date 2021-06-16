import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/views/charity/charity_donor.dart';
import 'package:drp_basket_app/views/charity/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonorRequestEnd extends StatelessWidget {
  final DonorModel donorModel;
  final dynamic requestID;
  final Map<String, dynamic> requestData;
  const DonorRequestEnd(this.donorModel, this.requestID, this.requestData,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      DonorPageUtilities.introRow(donorModel),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header("Collection Arrangement"),
            _bodyText('Date : ${requestData["collect_date"]}', 15),
            _bodyText('Collect by ${requestData["collect_time"]}', 15),
            _header("Donation Information"),
            _subHeader("Food items", 15),
            _bodyText(requestData["items"], 30),
            _bodyText('Total portions : ${requestData["portions"]}', 30),
          ],
        ),
      ),
    ];

    // If dietary options were specified
    if (requestData["options"] != "") {
      children.add(_subHeader("Dietary Options", 30));
      children.add(_bodyText(requestData["options"], 45));
    }
    if (requestData["status"] == "confirmed") {
      children.add(_confirmationButtons(context));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Request Information"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _header(String text) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _subHeader(String text, double padding) {
    return Padding(
      padding: EdgeInsets.only(
        left: padding,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _bodyText(String text, double padding) {
    return Padding(
      padding: EdgeInsets.only(
        left: padding,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: third_color,
        ),
      ),
    );
  }

  Widget _confirmationButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: [
          Spacer(),
          Expanded(
            flex: 6,
            child: ElevatedButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) => _confirmDialog(context, false),
                )
              },
              child: Text("Unsuccessful"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[600]),
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 6,
            child: ElevatedButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) => _confirmDialog(context, true),
                )
              },
              child: Text("Successful"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(secondary_color),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _confirmDialog(BuildContext context, bool successful) {
    TextEditingController _unsuccessfulMessage = TextEditingController();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        title: Text('This request is ${!successful ? "un" : ""}successful'),
        content: !successful
            ? TextField(
                decoration: InputDecoration(
                  labelText: "Message (optional)",
                  filled: true,
                  fillColor: Colors.grey[250],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondary_color, width: 2.0),
                  ),
                  border: null,
                ),
                controller: _unsuccessfulMessage,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              )
            : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _markNewStatus(successful, _unsuccessfulMessage);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _markNewStatus(
      bool successful, TextEditingController unsuccessfulMessage) async {
    String status = !successful ? "un" : "";
    status += "successful";

    DocumentReference reqRef = locator<FirebaseFirestoreInterface>()
        .getCollection("donors")
        .doc(donorModel.uid)
        .collection("requests")
        .doc(requestID);
    Map<String, dynamic> updateMap = {
      "status": status,
      "completion_time": Timestamp.now(),
    };
    if (!successful && unsuccessfulMessage.text != "") {
      updateMap["message"] = unsuccessfulMessage.text;
    }
    await reqRef.update(updateMap);

    DocumentReference charityRef = locator<FirebaseFirestoreInterface>()
        .getCollection("charities")
        .doc("ex-charity")
        .collection("donors")
        .doc(donorModel.uid);

    var charityData = await charityRef.get();
    var charityMap = charityData.data() as Map<String, dynamic>;

    List<dynamic> ongoingReqIDs = charityMap["ongoing_requests"];
    ongoingReqIDs.remove(requestID);
    List<dynamic> pastReqIDs = charityMap["past_requests"];
    pastReqIDs.add(requestID);

    await charityRef.update({
      "ongoing_requests": ongoingReqIDs,
      "past_requests": pastReqIDs,
    });
  }
}
