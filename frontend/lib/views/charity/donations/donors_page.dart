import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/views/charity/donations/donor_page.dart';
import 'package:drp_basket_app/views/general/donor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Page displaying list of donors (onTap -> `donor_page`)

class DonorsPage extends StatefulWidget {
  const DonorsPage({Key? key}) : super(key: key);

  @override
  _DonorsPageState createState() => _DonorsPageState();
}

class _DonorsPageState extends State<DonorsPage> {
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
              Donor curDonorModel = Donor(
                  donorIDs[i],
                  donorDatas[i]["name"],
                  donorDatas[i]["email"],
                  donorDatas[i]["address"],
                  donorDatas[i]["contact_number"],
                  donorDatas[i]["donation_count"],
                  imageProvider: data[i]);
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

  Widget _buildCard(Donor donorModel) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Provider<Donor>(
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
                      backgroundImage: donorModel.imageProvider,
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
