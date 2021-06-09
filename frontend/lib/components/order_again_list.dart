import 'package:drp_basket_app/components/donor_thumbnail.dart';
import 'package:drp_basket_app/view_controllers/receiver_controller.dart';
import 'package:flutter/material.dart';

import '../locator.dart';


class OrderAgainList extends StatefulWidget {
  const OrderAgainList({Key? key}) : super(key: key);

  @override
  _OrderAgainListState createState() => _OrderAgainListState();
}

class _OrderAgainListState extends State<OrderAgainList> {

  List<DonorThumbnail> donorThumbnails = [];

  void getOrderAgainList() async {
    donorThumbnails = await locator<ReceiverController>().getOrderAgainList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrderAgainList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: donorThumbnails,
      ),
    );
  }
}
