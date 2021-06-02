import 'package:drp_basket_app/components/long_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorHomePage extends StatefulWidget {
  static const String id = "DonorHomePage";

  const DonorHomePage({Key? key}): super(key: key);

  @override
  _DonorHomePageState createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  late String _foodName;
  int _foodCount = 0;
  final _fireStore = FirebaseFirestore.instance;
  TextEditingController _foodNameController = TextEditingController();

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

  void _addToFireBase() async {
    //TODO should be donor login username for doc after implementing auth
    DocumentSnapshot ds = await _fireStore.collection("restaurants").doc("vincent's store").get();
    int originalAmount = 0;
    _foodName = _foodName.toLowerCase();
    if ((ds.data() as Map<String, dynamic>).cast().containsKey(_foodName)) {
      originalAmount = await (ds.data() as Map<String, dynamic>)[_foodName];
    }
    print(originalAmount);
    int newAmount = originalAmount + _foodCount;
    _fireStore.collection("restaurants").doc("vincent's store").update({
      _foodName: newAmount,
    });
    _foodNameController.clear();
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
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: _foodNameController,
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                _foodName = value;
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.black54),
                hintText: 'Enter your food',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
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
                  backgroundColor: _foodCount > 0 ? Colors.blue : Colors.grey,
                ),
                SizedBox(
                  width: 10.0,
                ),
                FloatingActionButton(
                  heroTag: "BtnPlus",
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            LongButton(
              text: "Add Food",
              onPressed: _addToFireBase,
              backgroundColor: Colors.greenAccent,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
