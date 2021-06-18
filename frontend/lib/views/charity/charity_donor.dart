import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/views/charity/donor_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharityDonor extends StatefulWidget {
  const CharityDonor({Key? key}) : super(key: key);

  @override
  _CharityDonorState createState() => _CharityDonorState();
}

class _CharityDonorState extends State<CharityDonor> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _donorsStream =
        locator<FirebaseFirestoreInterface>()
            .getCollection("donors")
            .snapshots();

    return StreamBuilder(
      stream: _donorsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "No donors",
              style: TextStyle(
                color: third_color,
                fontSize: 24,
              ),
            ),
          );
        }
        List<String> donorIDs = [];
        List<dynamic> donorDatas = [];
        snapshot.data.docs.forEach((doc) {
          donorIDs.add(doc.id);
          donorDatas.add(doc.data());
        });
        // Each set will be donorData, donorImage
        List<Future> futures = [];
        donorIDs.forEach((req) {
          futures.add(_getImage(req));
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
            List<Widget> children = [];
            List<dynamic> data = snapshot.data!;
            for (int i = 0; i < data.length; i++) {
              DonorModel curDonorModel = DonorModel(
                  donorIDs[i],
                  donorDatas[i]["name"],
                  donorDatas[i]["address"],
                  donorDatas[i]["contact_number"],
                  data[i]);
              children.add(_buildCard(curDonorModel));
            }
            return ListView(
              children: children,
            );
          },
        );
      },
    );
  }

  Future<ImageProvider> _getImage(String uid) async {
    String downloadUrl = await locator<FirebaseStorageInterface>()
        .getImageUrl(UserType.DONOR, uid);
    return NetworkImage(downloadUrl);
  }

  Widget _buildCard(DonorModel donorModel) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Provider<DonorModel>(
                      create: (context) => donorModel,
                      child: DonorPage(),
                    )))
      },
      child: Card(
          shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          child: Row(
            children: [
              Spacer(),
              Expanded(
                flex: 13,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: CircleAvatar(
                      backgroundImage: donorModel.image,
                      radius: 50,
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
          )),
    );
  }
}

class DonorModel {
  final String uid;
  final String name;
  final String address;
  final String contactNumber;
  final ImageProvider image;

  DonorModel(this.uid, this.name, this.address, this.contactNumber, this.image);
}
