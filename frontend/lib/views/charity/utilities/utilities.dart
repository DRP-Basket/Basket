import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utilities {
    // Loading widget while waiting for data
  static Widget loading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  DateFormat df = DateFormat('EEE, d MMM yyyy, hh:mm aaa');
  return df.format(dateTime);
}