import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:telephony/telephony.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DateTimePicker extends StatefulWidget {

  final TextEditingController _dateController;

  DateTimePicker(this._dateController);

  @override
  _DateTimePickerState createState() => _DateTimePickerState(_dateController);
}

class _DateTimePickerState extends State<DateTimePicker> {

  String date = "Choose Event Date";

  final TextEditingController _dateController;

  _DateTimePickerState(this._dateController); 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 20),
                    Text('$date'),
                  ],
                ),
              ),
              onPressed: () {
                DatePicker.showDatePicker(
                  context,
                  onConfirm: (DateTime d) {
                    date = '${d.year} - ${d.month} - ${d.day}';
                    _dateController.text = date;
                    setState(() {});
                  },
                );
              }),
        ],
      ),
    );
  }
}


class SMSSender {

  final Telephony telephony = Telephony.instance;
  final _fireStore = FirebaseFirestore.instance;

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String getRedeemURL(String uid, String did) {
    String redeemCode = getRandomString(5);
    String url = "www.xxxxxx.com/redeem$redeemCode";
    _fireStore.collection("redeem").doc(redeemCode).set({
      "user": uid,
      "donation_event": did
    });
    return url;
  }

  void sendSMS(context, donationID, {msgContent = ''}) async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted!) {
      DocumentSnapshot ds =
          await _fireStore.collection("charities").doc("ex-charity").get();
      List contacts = (ds.data() as Map<String, dynamic>)["contact_list"] as List;
      for (Map<String, dynamic> contact in contacts) {
        print(contact["uid"]);
        String redemption_link = "Please click on the link ${getRedeemURL(contact["uid"], donationID)} when you collect your food.";
        telephony.sendSms(to: contact["Contact"], message: msgContent + '\n' + redemption_link);
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
}