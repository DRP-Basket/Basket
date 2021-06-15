import 'package:flutter/material.dart';

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