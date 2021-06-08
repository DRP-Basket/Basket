import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:flutter/material.dart';

class FoodScreen extends StatefulWidget {
  final String foodName;
  final int foodLimit;
  final String restaurantName;
  const FoodScreen({Key? key, required this.restaurantName, required this.foodName, required this.foodLimit}) : super(key: key);

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final _fireStore = FirebaseFirestore.instance;
  int _foodCount = 0;
  void _incrementCounter() {
    setState(() {
      _foodCount++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _foodCount--;
    });
  }

  void buyFood() async {
    DocumentSnapshot ds = await _fireStore.collection("restaurants").doc(widget.restaurantName).get();
    int originalAmount = 0;
    if ((ds.data() as Map<String, dynamic>).cast().containsKey(widget.foodName)) {
      originalAmount = await (ds.data() as Map<String, dynamic>)[widget.foodName];
    }
    print(originalAmount);
    int newAmount = originalAmount - _foodCount;
    if (newAmount == 0) {
      _fireStore.collection("restaurants").doc(widget.restaurantName).update({
        widget.foodName: FieldValue.delete()
      });
    } else {
      _fireStore.collection("restaurants").doc(widget.restaurantName).update({
        widget.foodName: newAmount,
      });
    }
    setState(() {
      _foodCount = 0;
    });
  }

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
        title: Text("Donor Home Page"),
        backgroundColor: Colors.orangeAccent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text(
              '${widget.foodName}',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              '$_foodCount',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "BtnMinus",
                  onPressed: _foodCount > 0 ? _decrementCounter : null,
                  tooltip: 'Decrement',
                  child: Icon(Icons.remove),
                  backgroundColor: _foodCount > 0 ? Colors.orangeAccent : Colors.grey,
                ),
                SizedBox(
                  width: 10.0,
                ),
                FloatingActionButton(
                  heroTag: "BtnPlus",
                  onPressed: _foodCount < widget.foodLimit ? _incrementCounter : null,
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                  backgroundColor: _foodCount < widget.foodLimit ? Colors.orangeAccent : Colors.grey,
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            LongButton(
              text: "Buy Food",
              onPressed: buyFood,
              backgroundColor: Colors.pinkAccent,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
