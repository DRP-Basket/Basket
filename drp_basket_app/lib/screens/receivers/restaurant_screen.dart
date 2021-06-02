import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'food_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final String restaurantName;

  const RestaurantScreen({Key? key, required this.restaurantName})
      : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final _fireBase = FirebaseFirestore.instance;

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
        title: Text(widget.restaurantName),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: StreamBuilder(
          stream: _fireBase
              .collection("restaurants")
              .doc(widget.restaurantName)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            List<ItemButton> itemButtons = [];
            final foodItemMap = (snapshot.data as DocumentSnapshot);
            final foodItems = (foodItemMap.data() as Map<String, dynamic>);
            for (var foodName in foodItems.keys) {
              itemButtons.add(ItemButton(
                  restaurantName: widget.restaurantName,
                  foodName: foodName,
                  foodCount: foodItems[foodName]));
            }
            return Column(
              children: itemButtons,
            );
          },
        ),
      ),
    );
  }
}

class ItemButton extends StatelessWidget {
  final String foodName;
  final int foodCount;
  final String restaurantName;

  const ItemButton(
      {Key? key,
      required this.restaurantName,
      required this.foodName,
      required this.foodCount})
      : super(key: key);

  void foodDetails(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FoodScreen(
          restaurantName: restaurantName,
          foodName: foodName,
          foodLimit: foodCount);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: GestureDetector(
        onTap: () => foodDetails(context),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          color: Colors.orangeAccent,
          child: Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      foodName,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Amount: $foodCount",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
