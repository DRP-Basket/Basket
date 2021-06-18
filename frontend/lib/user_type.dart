import 'package:drp_basket_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum UserType {
  DONOR,
  CHARITY,
  FOOD_BANK,
  RECEIVER,
}

const Map<UserType, String> userTypeString = {
  UserType.DONOR: "Business",
  UserType.CHARITY: "Charity",
  UserType.FOOD_BANK: "Food Bank",
};

const Map<UserType, Color> userColorTheme = {
  UserType.DONOR: secondary_color,
  UserType.CHARITY: primary_color,
  UserType.FOOD_BANK: Colors.purpleAccent,
};

const Map<UserType, String> cloudCollection = {
  UserType.DONOR: "donors",
  UserType.CHARITY: "charities",
  UserType.RECEIVER: "receiver",
  UserType.FOOD_BANK: "foodbank",
};

const Map<UserType, String> cloudProfileFilePath = {
  UserType.DONOR: "donors/profile/",
  UserType.CHARITY: "charity/profile/",
  UserType.RECEIVER: "receiver/profile/",
  UserType.FOOD_BANK: "foodbank/profile/",
};
