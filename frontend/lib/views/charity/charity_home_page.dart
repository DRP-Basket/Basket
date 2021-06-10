import 'package:flutter/material.dart';

import 'charity_drawer.dart';

class CharityHomePage extends StatelessWidget {
  static const String id = "CharityHomePage";

  const CharityHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Charity Home Page")),
      drawer: CharityDrawer(),
    );
  }
}
