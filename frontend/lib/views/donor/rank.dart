import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Rank {
  BRONZE,
  SILVER,
  GOLD,
  PLATINUM,
  EMERALD,
  DIAMOND,
  MASTER,
  GRANDMASTER,
  CHALLENGER,
}

const Map<Rank, String> rankString = {
  Rank.BRONZE: "bronze",
  Rank.SILVER: "silver",
  Rank.GOLD: "gold",
  Rank.PLATINUM: "platinum",
  Rank.EMERALD: "emerald",
  Rank.DIAMOND: "diamond",
  Rank.MASTER: "master",
  Rank.GRANDMASTER: "grandmaster",
  Rank.CHALLENGER: "challenger",
};

String getImagePath(Rank rank) {
  return "images/rank/${rankString[rank]!}.png";
}

const Map<Rank, Color> rankColor = {
  Rank.BRONZE: Color(0xffcd7f32),
  Rank.SILVER: Color(0xffC0C0C0),
  Rank.GOLD: Color(0xffD4AF37),
  Rank.PLATINUM: Color(0xff02811b),
  Rank.EMERALD: Color(0xff008080),
  Rank.DIAMOND: Color(0xff8a2be2),
  Rank.MASTER: Color(0xff79029b),
  Rank.GRANDMASTER: Color(0xff990F02),
  Rank.CHALLENGER: Color(0xffFFD700),
};