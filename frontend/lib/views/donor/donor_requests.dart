import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/views/donor/donor_drawer.dart';
import 'package:drp_basket_app/views/donor/donor_respond.dart';
import "package:flutter/material.dart";

class DonorRequests extends StatefulWidget {
  static const id = "/donorRequests";
  final String curUID;
  const DonorRequests(this.curUID, {Key? key}) : super(key: key);

  @override
  _DonorRequestsState createState() => _DonorRequestsState();
}

class _DonorRequestsState extends State<DonorRequests> {
  List<String> statuses = [];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _requestStream =
        locator<FirebaseFirestoreInterface>()
            .getCollection("donors")
            .doc(widget.curUID)
            .collection("requests")
            .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
      ),
      drawer: DonorDrawer(),
      body: StreamBuilder(
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
            _changeStatus(info["status"], i);
            reqs.add(_buildCard(info["name"], info["message"], data[i].id, i));
          }
          return ListView(children: reqs);
        },
      ),
    );
  }

  Widget _buildCard(String name, String message, String reqID, int index) {
    return Card(
      child: ListTile(
        leading: _getIconFromStatus(statuses[index]),
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
        trailing: IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonorRespond(
                      name, message, index, _getStatus, widget.curUID, reqID),
                ));
          },
        ),
        isThreeLine: true,
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

  void _changeStatus(String status, int index) {
    if (index >= statuses.length) {
      statuses.add(status);
    } else {
      statuses[index] = status;
    }
  }

  String _getStatus(int index) {
    return statuses[index];
  }
}
