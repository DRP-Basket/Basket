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

const Map<UserType, String> cloudCollection = {
  UserType.DONOR: "donors",
  UserType.RECEIVER: "receivers",
  UserType.FOOD_BANK: "foodbank",
};

const Map<UserType, String> cloudProfileFilePath = {
  UserType.DONOR: "donors/profile/",
  UserType.RECEIVER: "receivers/profile/",
  UserType.FOOD_BANK: "foodbank/profile/",
};