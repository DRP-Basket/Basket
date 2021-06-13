import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donor/donor_respond.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class DonorRequests extends StatefulWidget {
  static const id = "/donorRequests";
  const DonorRequests({Key? key}) : super(key: key);

  @override
  _DonorRequestsState createState() => _DonorRequestsState();
}

class _DonorRequestsState extends State<DonorRequests> {
  late final String curUID;

  @override
  void initState() {
    super.initState();
    curUID = locator<UserController>().curUser()!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _requestStream =
        locator<FirebaseFirestoreInterface>()
            .getCollection("donors")
            .doc(curUID)
            .collection("requests")
            .snapshots();

    return StreamBuilder(
      stream: _requestStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        List<Widget> reqs = [];
        var data = snapshot.data!.docs;
        for (var i = 0; i < data.length; i++) {
          var info = data[i].data();
          reqs.add(_buildCard(
              info["name"], info["message"], info["status"], data[i].id));
        }
        return ListView(children: reqs);
      },
    );
  }

  Widget _buildCard(String name, String message, String status, String reqID) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider<RequestModel>(
                  create: (context) =>
                      RequestModel(name, message, status, curUID, reqID),
                  child: DonorRespond()),
            ));
      },
      child: Card(
        child: ListTile(
          leading: _getIconFromStatus(status),
          title: Text(
            name,
            style: TextStyle(fontSize: 21),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              message,
              style: TextStyle(fontSize: 14),
            ),
          ),
          isThreeLine: true,
        ),
      ),
    );
  }

  Widget _getIconFromStatus(String status) {
    if (status == "pending") {
      return Icon(
        Icons.pending_actions_outlined,
        color: Colors.orange,
        size: 40,
      );
    } else {
      return Icon(
        Icons.gpp_good_outlined,
        color: Colors.green,
        size: 40,
      );
    }
  }
}

class RequestModel {
  final String name;
  final String message;
  String status;
  final String curUID;
  final String reqID;

  RequestModel(this.name, this.message, this.status, this.curUID, this.reqID);
}
