import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donor/donor_respond.dart';
import 'package:drp_basket_app/views/donor/utilities.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        List<String> reqIDs = [];
        List<Map<String, dynamic>> requestData = [];
        List<Future> futures = [];
        var response = snapshot.data!.docs;

        // Sort to display newest request first
        response.sort((a, b) {
          Timestamp aTime = a.data()["create_time"];
          Timestamp bTime = b.data()["create_time"];
          return bTime.compareTo(aTime);
        });

        for (var i = 0; i < response.length; i++) {
          reqIDs.add(response[i].id);
          var info = response[i].data();
          requestData.add(info);
          _getFutures(info, futures);
        }

        return FutureBuilder(
            future: Future.wait(futures),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              List<Widget> reqs = [];
              if (snapshot.data != null) {
                for (int i = 0; i < snapshot.data!.length; i += 2) {
                  if (requestData[i ~/ 2]["status"] != "successful" ||
                      requestData[i ~/ 2]["status"] != "unsuccessful") {
                    reqs.add(_buildCard(reqIDs[i ~/ 2], requestData[i ~/ 2],
                        snapshot.data![i].data(), snapshot.data![i + 1]));
                  }
                }
              }
              if (snapshot.data == null || reqs.isEmpty) {
                return Center(child: Text("No requests"));
              }
              return ListView(
                children: reqs,
              );
            });
      },
    );
  }

  void _getFutures(Map<String, dynamic> data, List<Future> futures) {
    Future<DocumentSnapshot<Map<String, dynamic>>> charityInfo =
        locator<FirebaseFirestoreInterface>()
            .getCollection("charities")
            .doc(data["charity_uid"])
            .get();
    futures.add(charityInfo);
    Future<ImageProvider> imageProvider = _getImage(data["charity_uid"]);
    futures.add(imageProvider);
  }

  Future<ImageProvider> _getImage(String uid) async {
    String downloadUrl;
    try {
      downloadUrl = await locator<FirebaseStorageInterface>()
          .getImageUrl(UserType.CHARITY, uid);
    } catch (err) {
      downloadUrl =
          "https://i.pinimg.com/originals/59/54/b4/5954b408c66525ad932faa693a647e3f.jpg";
    }
    ImageProvider imageProvider = NetworkImage(downloadUrl);
    return imageProvider;
  }

  Widget _buildCard(String reqID, Map<String, dynamic> requestData,
      Map<String, dynamic> charityData, ImageProvider image) {
    List<String> timeStrings = DateTime.fromMicrosecondsSinceEpoch(
            requestData["create_time"].microsecondsSinceEpoch)
        .toString()
        .split(':');
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider<RequestModel>(
                  create: (context) => RequestModel(
                      curUID, reqID, charityData, requestData, image),
                  child: DonorRespond()),
            ));
      },
      child: Card(
        child: ListTile(
          leading: Image(
            image: image,
            width: MediaQuery.of(context).size.width / 3,
          ),
          title: Container(
            child: Text(
              charityData["name"],
              style: TextStyle(fontSize: 21),
            ),
            padding: EdgeInsets.only(top: 2.5, left: 10),
          ),
          subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sent at ${timeStrings[0]}:${timeStrings[1]}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7.5, left: 10),
                  child: getStatusText(requestData["status"], 15),
                )
              ]),
          isThreeLine: true,
        ),
      ),
    );
  }
}
