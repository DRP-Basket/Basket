import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:flutter/material.dart';

class DonorRespond extends StatefulWidget {
  final String name;
  final String message;
  final int index;
  final Function getStatus;
  final String curUID;
  final String reqID;
  const DonorRespond(this.name, this.message, this.index, this.getStatus,
      this.curUID, this.reqID,
      {Key? key})
      : super(key: key);

  @override
  _DonorRespondState createState() => _DonorRespondState();
}

class _DonorRespondState extends State<DonorRespond> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.getStatus(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: _message(),
      ),
    );
  }

  Widget _message() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text("Message",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          padding: EdgeInsets.only(top: 10),
        ),
        Container(
          child: Text(widget.message, style: TextStyle(fontSize: 16)),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        _statusText(),
        _getButtonBar(),
      ],
    );
  }

  Widget _statusText() {
    List<TextSpan> children = [];
    if (status == "pending") {
      children.add(TextSpan(
          text: "pending",
          style: TextStyle(color: Colors.orange[800], fontSize: 20)));
    } else {
      children.add(TextSpan(
          text: "confirmed",
          style: TextStyle(color: Colors.green[800], fontSize: 20)));
    }
    return Container(
        padding: EdgeInsets.only(top: 15),
        child: RichText(
            text: TextSpan(
                text: "Status: ",
                style: TextStyle(color: Colors.black, fontSize: 20),
                children: children)));
  }

  Widget _getButtonBar() {
    List<Widget> children = [];
    if (status == "pending") {
      children.add(ElevatedButton(onPressed: null, child: Text("Delete")));
      children.add(ElevatedButton(
        onPressed: () {
          _statusTap(true);
        },
        child: Text("Confirm"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(fourth_color)),
      ));
    } else {
      children.add(ElevatedButton(
        onPressed: () {
          _statusTap(false);
        },
        child: Text("Delete"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
        ),
      ));
      children.add(ElevatedButton(onPressed: null, child: Text("Confirm")));
    }
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: children,
    );
  }

  void _statusTap(bool confirm) async {
    final DocumentReference ref = FirebaseFirestore.instance
        .collection("donors")
        .doc(widget.curUID)
        .collection("requests")
        .doc(widget.reqID);
    if (confirm) {
      await ref.update({"status": "confirmed"}).catchError(
          (error) => print(error.toString()));
    } else {
      await ref.update({"status": "pending"}).catchError(
          (error) => print(error.toString()));
    }
    setState(() {
      status = widget.getStatus(widget.index);
    });
  }
}
