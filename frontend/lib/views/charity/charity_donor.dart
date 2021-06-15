import 'package:drp_basket_app/views/charity/charity_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CharityDonor extends StatefulWidget {
  const CharityDonor({Key? key}) : super(key: key);

  @override
  _CharityDonorState createState() => _CharityDonorState();
}

class _CharityDonorState extends State<CharityDonor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donors"),
      ),
      drawer: CharityDrawer(),
    );
  }
}
