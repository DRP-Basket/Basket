import 'package:drp_basket_app/views/donor/rank.dart';
import 'package:flutter/material.dart';

class RankExplanationScreen extends StatelessWidget {
  const RankExplanationScreen({Key? key}) : super(key: key);

  List<Widget> initRankItems() {
    List<Widget> rankItems = [];
    Rank.values.forEach((rank) {
      rankItems.add(Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            getImagePath(rank),
            height: 100.0,
          ),
          Text(rankString[rank]!.toUpperCase()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Orders: "),
              Text(rankDonationCaps[rank]!.toString()),
            ],
          ),
        ],
      ));
    });

    return rankItems.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Appreciation Rank Stats",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Stack(
          children: [
            GridView.count(
              mainAxisSpacing: 30.0,
              crossAxisCount: 3,
              children: initRankItems(),
            ),
          ],
        ),
      ),
    );
  }
}
