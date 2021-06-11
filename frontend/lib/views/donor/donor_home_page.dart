import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/donor/donor_add_item.dart';
import 'package:flutter/material.dart';

import 'donor_drawer.dart';

class DonorHomePage extends StatefulWidget {
  static const String id = "DonorHomePage";

  const DonorHomePage({Key? key}) : super(key: key);

  @override
  _DonorHomePageState createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Donations"),
      ),
      drawer: DonorDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DonorAddItem()));
        },
        child: Icon(Icons.add),
        backgroundColor: secondary_color,
      ),
        body: StreamBuilder(
            stream:
            _fireStore.collection("restaurants").doc("vincent's store").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              } else {
                final foodDS = (snapshot.data as DocumentSnapshot);
                final foodMap = (foodDS.data() as Map<String, dynamic>);
                List<Widget> foodItems = [];
                for (var food in foodMap.keys) {
                  foodItems.add(Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(food),
                          Text(foodMap[food].toString()),
                        ],
                      ),
                    ),
                  ));
                }
                return ListView(
                  children: foodItems,
                );
              }
            }),
    );
  }
}
