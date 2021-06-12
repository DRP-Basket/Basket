import 'package:drp_basket_app/views/donor/rank.dart';
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
  Rank rank = Rank.CHALLENGER;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        if (controller.value > 0.7) {
          controller.stop();
        }
        setState(() {});
      });
    controller.forward();
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
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            CircularPercentIndicator(
              percent: controller.value,
              lineWidth: 13.0,
              progressColor: rankColor[rank],
              backgroundColor: Colors.grey,
              radius: 200.0,
              center: SizedBox(
                height: 150.0,
                width: 150.0,
                child: Image.asset(getImagePath(rank)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
