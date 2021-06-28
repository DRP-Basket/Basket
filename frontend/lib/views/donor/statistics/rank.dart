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

Rank? nextRank(Rank rank) {
  switch (rank) {
    case Rank.BRONZE:
      return Rank.SILVER;
    case Rank.SILVER:
      return Rank.GOLD;
    case Rank.GOLD:
      return Rank.PLATINUM;
    case Rank.PLATINUM:
      return Rank.EMERALD;
    case Rank.EMERALD:
      return Rank.DIAMOND;
    case Rank.DIAMOND:
      return Rank.MASTER;
    case Rank.MASTER:
      return Rank.GRANDMASTER;
    case Rank.GRANDMASTER:
      return Rank.CHALLENGER;
    case Rank.CHALLENGER:
      return null;
  }
}

const Map<Rank, String> rankString = {
  Rank.BRONZE: "Bronze",
  Rank.SILVER: "Silver",
  Rank.GOLD: "Gold",
  Rank.PLATINUM: "Platinum",
  Rank.EMERALD: "Emerald",
  Rank.DIAMOND: "Diamond",
  Rank.MASTER: "Master",
  Rank.GRANDMASTER: "Grandmaster",
  Rank.CHALLENGER: "Challenger",
};

String getImagePath(Rank rank) {
  return "images/rank/${rankString[rank]!}.png";
}

const Map<Rank, int> rankDonationCaps = {
  Rank.BRONZE: 0,
  Rank.SILVER: 50,
  Rank.GOLD: 100,
  Rank.PLATINUM: 200,
  Rank.EMERALD: 400,
  Rank.DIAMOND: 800,
  Rank.MASTER: 1600,
  Rank.GRANDMASTER: 3200,
  Rank.CHALLENGER: 6400,
};

Rank getRank(int donations) {
  if (donations > 6400) {
    return Rank.CHALLENGER;
  } else if (donations > 3200) {
    return Rank.GRANDMASTER;
  } else if (donations > 1600) {
    return Rank.MASTER;
  } else if (donations > 800) {
    return Rank.DIAMOND;
  } else if (donations > 400) {
    return Rank.EMERALD;
  } else if (donations > 200) {
    return Rank.PLATINUM;
  } else if (donations > 100) {
    return Rank.GOLD;
  } else if (donations > 50) {
    return Rank.SILVER;
  } else {
    return Rank.BRONZE;
  }
}

double getProgressPercent(Rank rank, int donations) {
  if (rank == Rank.CHALLENGER) {
    return 1.0;
  }
  return donations / rankDonationCaps[nextRank(rank)]!;
}

int getAmountNeededForNextPoint(Rank rank, int donations) {
  if (rank == Rank.CHALLENGER) {
    return 0;
  }
  return rankDonationCaps[nextRank(rank)]! - donations;
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
