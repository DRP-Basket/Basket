import 'package:drp_basket_app/view_controllers/receiver_controller.dart';
import 'package:flutter/material.dart';

import '../locator.dart';


class DonorNearByList extends StatelessWidget {
  DonorNearByList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: locator<ReceiverController>().getDonorStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        return Container(
          margin: EdgeInsets.only(top: 10.0),
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: locator<ReceiverController>().generateThumbnail(snapshot),
          ),
        );
      },
    );
  }
}