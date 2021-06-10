import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'charity_drawer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class CharityHomePage extends StatelessWidget {
  static const String id = "CharityHomePage";

  CharityHomePage({Key? key}) : super(key: key);
  final Telephony telephony = Telephony.instance;
  final _fireStore = FirebaseFirestore.instance;

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String getRedeemURL(String uid) {
    String redeemCode = getRandomString(5);
    String url = "www.xxxxxx.com/redeem$redeemCode";
    _fireStore.collection("redeem").doc(redeemCode).set({
      "user": uid
    });
    return url;
  }

  void sendSMS(context) async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted!) {
      DocumentSnapshot ds =
          await _fireStore.collection("charities").doc("ex-charity").get();
      List contacts = (ds.data() as Map<String, dynamic>)["contact_list"] as List;
      for (Map<String, dynamic> contact in contacts) {
        print(contact["uid"]);
        String message = "Please click on the link ${getRedeemURL(contact["uid"])} when you collect your food.";
        telephony.sendSms(to: contact["Contact"], message: message);
      }
    }
    Alert(
        context: context,
        title: "Message Sent",
        desc: "Messages have been sent out",
        type: AlertType.success,
        buttons: [
          DialogButton(
            child: Text(
              "Exit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Charity Home Page")),
      drawer: CharityDrawer(),
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
            onPressed: () => sendSMS(context),
          ),
        ),
      ),
    );
  }
}
