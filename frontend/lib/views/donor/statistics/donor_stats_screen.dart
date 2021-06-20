import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donor/statistics/rank.dart';
import 'package:drp_basket_app/views/donor/statistics/rank_explaination_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DonorStatsPage extends StatefulWidget {
  static const String id = "DonorStats";

  const DonorStatsPage({Key? key}) : super(key: key);

  @override
  _DonorStatsPageState createState() => _DonorStatsPageState();
}

class _DonorStatsPageState extends State<DonorStatsPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Rank rank;
  late double progressPercent;
  late int donations;
  bool loading = true;

  void initDonation() async {
    // TODO when implemented login stuff, use user controller to get stats
    String userID = locator<UserController>().curUser()!.uid;
    donations =
        await locator<FirebaseFirestoreInterface>().getDonationCount(userID);
    rank = getRank(donations);
    loading = false;
    progressPercent = getProgressPercent(rank, donations);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        if (controller.value > progressPercent) {
          controller.stop();
        }
        setState(() {});
      });
    controller.forward();
  }

  @override
  void initState() {
    initDonation();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Stats'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(
                30.0,
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Rank",
                      style: new TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RankExplanationScreen(),
                        ),
                      ),
                      child: CircularPercentIndicator(
                        percent: controller.value,
                        lineWidth: 13.0,
                        progressColor: rankColor[rank],
                        backgroundColor: Colors.grey,
                        radius: 200.0,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: SizedBox(
                          height: 150.0,
                          width: 150.0,
                          child: Image.asset(getImagePath(rank)),
                        ),
                        footer: Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Text(
                            rankString[rank]!.toUpperCase(),
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "Statistics",
                      style: new TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Orders made: "),
                        Text(donations.toString()),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Orders for next rank: "),
                        Text(
                          getAmountNeededForNextPoint(rank, donations)
                              .toString(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Next rank: "),
                        Text(
                          nextRank(rank) != null
                              ? rankString[nextRank(rank)]!.toUpperCase()
                              : "Max rank reached",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      backgroundColor: Colors.white,
    );
  }
}
