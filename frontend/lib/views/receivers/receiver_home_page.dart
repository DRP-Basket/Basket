import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/views/receivers/restaurant_screen.dart';
import 'package:flutter/material.dart';

class ReceiverHomePage extends StatefulWidget {
  static const String id = "ReceiverHomePage";

  const ReceiverHomePage({Key? key}): super(key: key);

  @override
  _ReceiverHomePageState createState() => _ReceiverHomePageState();
}

class _ReceiverHomePageState extends State<ReceiverHomePage> {
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
      appBar: AppBar(
        title: Text("Receiver Home Page"),
        backgroundColor: Colors.greenAccent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            RestaurantsStream(),
          ],
        ),
      ),
    );
  }
}

class RestaurantsStream extends StatelessWidget {
  final _fireStore = FirebaseFirestore.instance;

  RestaurantsStream({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fireStore.collection("restaurants").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        List<RestaurantButton> restaurantButtons = [];
        final restaurants = (snapshot.data as QuerySnapshot).docs.reversed;
        for (var restaurant in restaurants) {
          restaurantButtons.add(RestaurantButton(restaurantName: restaurant.id));
        }
        return Column(
          children: restaurantButtons,
        );
      },
    );
  }
}

class RestaurantButton extends StatelessWidget {
  final String restaurantName;

  RestaurantButton({Key? key, required this.restaurantName}): super(key: key);

  void restaurantDetails(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RestaurantScreen(restaurantName: restaurantName);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: GestureDetector(
        onTap: () => restaurantDetails(context),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          color: Colors.deepPurpleAccent,
          child: Container(
            height: 50,
            child: Center(
              child: Text(
                restaurantName,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
