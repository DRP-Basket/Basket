import 'package:drp_basket_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorRequestEnd extends StatelessWidget {
  const DonorRequestEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> requestData = Provider.of(context);

    const TextStyle headerStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );

    const TextStyle subHeaderStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );

    const TextStyle bodyStyle = TextStyle(
      fontSize: 18,
      color: third_color,
    );

    List<Widget> children = [
      Text(
        "Colletion Arrangment",
        style: headerStyle,
      ),
      Text(
        'Date : ${requestData["collect_date"]}',
        style: bodyStyle,
      ),
      Text(
        'Collect by ${requestData["collect_time"]}',
        style: bodyStyle,
      ),
      Text(
        "Donation Information",
        style: headerStyle,
      ),
      Text(
        "Food items",
        style: subHeaderStyle,
      ),
      Text(
        requestData["items"],
        style: bodyStyle,
      ),
      Text(
        'Total portions : ${requestData["portions"]}',
        style: bodyStyle,
      ),
    ];
    if (requestData["options"] != "") {
      children.add(Text(
        "Options",
        style: headerStyle,
      ));
      children.add(
        Text(
          requestData["options"],
          style: bodyStyle,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Information"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
