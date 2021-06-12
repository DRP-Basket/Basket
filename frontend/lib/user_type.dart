import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum UserType {
  DONOR,
  CHARITY,
  FOOD_BANK,
  RECEIVER,
}

const Map<UserType, Color> userColorTheme = {
  UserType.DONOR: Colors.blueAccent,
  UserType.CHARITY: Colors.greenAccent,
  UserType.FOOD_BANK: Colors.purpleAccent,
};

const Map<UserType, String> cloudCollection = {
  UserType.DONOR: "donors",
  UserType.CHARITY: "charity",
  UserType.RECEIVER: "receiver",
  UserType.FOOD_BANK: "foodbank",
};

const Map<UserType, String> cloudProfileFilePath = {
  UserType.DONOR: "donors/profile/",
  UserType.CHARITY: "charity/profile/",
  UserType.RECEIVER: "receiver/profile/",
  UserType.FOOD_BANK: "foodbank/profile/",
};