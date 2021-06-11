import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/donor/donor_add_item.dart';
import 'package:flutter/material.dart';

import 'donor_drawer.dart';

class DonorHomePage extends StatefulWidget {
  static const String id = "DonorHomePage";

  const DonorHomePage({Key? key}) : super(key: key);

  @override
  _DonorHomePageState createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Donations"),
      ),
      drawer: DonorDrawer(),
      body: Text("Hello"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DonorAddItem()));
        },
        child: Icon(Icons.add),
        backgroundColor: secondary_color,
      ),
    );
  }
}
