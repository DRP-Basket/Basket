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

String formatDateTime(DateTime dateTime, {String format: 'EEE, d MMM yyyy, hh:mm aaa'}) {
  DateFormat df = DateFormat(format);
  return df.format(dateTime);
}