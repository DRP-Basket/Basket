import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/donor/donor_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drp_basket_app/views/donor/utilities.dart';

class DonorRespond extends StatefulWidget {
  const DonorRespond({Key? key}) : super(key: key);

  @override
  _DonorRespondState createState() => _DonorRespondState();
}

class _DonorRespondState extends State<DonorRespond> {
  late RequestModel requestModel;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    requestModel = Provider.of(context);
    print(requestModel.requestData);

    return Scaffold(
      appBar: AppBar(
        title: Text(requestModel.charityData["name"]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: !loading
              ? _body()
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _body() {
    List<String> timeStrings = DateTime.fromMicrosecondsSinceEpoch(
            requestModel.requestData["create_time"].microsecondsSinceEpoch)
        .toString()
        .split(':');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            'Sent at ${timeStrings[0]}:${timeStrings[1]}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Image(
          image: requestModel.image,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          child: Text("Description",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          padding: EdgeInsets.only(top: 5),
        ),
        Container(
          child: Text(requestModel.charityData["description"],
              style: TextStyle(fontSize: 16)),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        Container(
          child: Text("Contact",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          padding: EdgeInsets.only(top: 10),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (requestModel.charityData["contact_number"] != null)
              Container(
                child: Text(requestModel.charityData["contact_number"],
                    style: TextStyle(fontSize: 16)),
                padding: EdgeInsets.only(top: 5),
              ),
            if (requestModel.charityData["email_address"] != null)
              Container(
                child: Text(requestModel.charityData["email_address"],
                    style: TextStyle(fontSize: 16)),
                padding: EdgeInsets.only(top: 2.5),
              ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.only(top: 30),
              child: getStatusText(requestModel.requestData["status"], 24))
        ]),
        if (requestModel.requestData["status"] == "pending") _getButtonBar(),
        if (requestModel.requestData["status"] == "confirmed")
          _getDonationInfo(),
      ],
    );
  }

  Widget _getButtonBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => showDialog(
              context: context, builder: (context) => _getDeleteDialog()),
          child: Text(
            "Delete",
            style: TextStyle(fontSize: 18),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.deepOrange),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Provider(
                        create: (context) => requestModel,
                        child: DonorMessage())));
            // _statusTap(true);
          },
          child: Text(
            "Accept",
            style: TextStyle(fontSize: 18),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(secondary_color)),
        ),
      ],
    );
  }

  Widget _getDeleteDialog() {
    return AlertDialog(
      title: Text("Are you sure?"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _deleteTap(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Future<void> _deleteTap() async {
    final DocumentReference ref = FirebaseFirestore.instance
        .collection("donors")
        .doc(requestModel.curUID)
        .collection("requests")
        .doc(requestModel.reqID);
    Navigator.pop(context);
    setState(() {
      loading = true;
    });
    await ref.delete().then((value) => Navigator.pop(context));
  }

  Widget _getDonationInfo() {
    return Container();
  }
}
