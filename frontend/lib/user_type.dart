import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum UserType {
  DONOR,
  RECEIVER,
  FOOD_BANK,
}

const Map<UserType, Color> userColorTheme = {
  UserType.DONOR: Colors.blueAccent,
  UserType.RECEIVER: Colors.greenAccent,
  UserType.FOOD_BANK: Colors.purpleAccent,
};

const Map<UserType, String> cloudFilePath = {
  UserType.DONOR: "donors/",
  UserType.RECEIVER: "",
  UserType.FOOD_BANK: "foodbank/",
};