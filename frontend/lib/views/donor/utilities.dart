import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RequestModel {
  final String curUID;
  final String reqID;
  final Map<String, dynamic> charityData;
  final Map<String, dynamic> requestData;
  final ImageProvider image;

  RequestModel(
      this.curUID, this.reqID, this.charityData, this.requestData, this.image);
}

class DonorRequestUtilities {
  static Widget getStatusText(String status, double size) {
    List<TextSpan> children = [];
    if (status == "pending") {
      children.add(TextSpan(
          text: "pending",
          style: TextStyle(color: Colors.orange[900], fontSize: size)));
    } else {
      children.add(TextSpan(
          text: "confirmed",
          style: TextStyle(color: Colors.green[800], fontSize: size)));
    }
    return RichText(
        text: TextSpan(
            text: "Status: ",
            style: TextStyle(color: Colors.black, fontSize: size),
            children: children));
  }

  static String getTimeString(Timestamp time) {
    List<String> timeStrings =
        DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch)
            .toString()
            .split(':');
    return timeStrings[0] + ':' + timeStrings[1];
  }
}
