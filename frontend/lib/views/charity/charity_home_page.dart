import 'package:flutter/material.dart';

class CharityHomePage extends StatelessWidget {
  static const String id = "CharityHomePage";

  CharityHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Charity Home Page")),
      body: Center(
        child: CircleAvatar(
          radius: 50.0,
          backgroundColor: Colors.blue,
          child: IconButton(
            icon: Icon(
              Icons.add_alert,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {}, // () => {SMSSender().sendSMS(context),}
          ),
        ),
      ),
    );
  }
}
