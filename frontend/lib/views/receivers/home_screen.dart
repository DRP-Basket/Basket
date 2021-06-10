import 'package:drp_basket_app/components/donors_nearby_list.dart';
import 'package:drp_basket_app/components/order_again_list.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/auth/login_screen.dart';
import 'package:flutter/material.dart';

class ReceiverHomeScreen extends StatefulWidget {
  static const String id = "ReceiverHomeScreen";

  const ReceiverHomeScreen({Key? key}) : super(key: key);

  @override
  _ReceiverHomeScreenState createState() => _ReceiverHomeScreenState();
}

class _ReceiverHomeScreenState extends State<ReceiverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receiver Home Page"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () async => {
              await locator<UserController>().userSignOut(),
              Navigator.popUntil(context, ModalRoute.withName(LoginScreen.id))
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  "Donors Near By",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            DonorNearByList(),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  "Order Again",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            OrderAgainList(),
          ],
        ),
      ),
    );
  }
}
