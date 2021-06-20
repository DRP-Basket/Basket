import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/charity/requests/requests_page.dart';
import 'package:flutter/material.dart';

class RequestsMain extends StatelessWidget {
  static String id = "CharityRequestsMain";

  const RequestsMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.25),
                  bottom: BorderSide(color: Colors.grey, width: 0.25),
                ),
              ),
              child: TabBar(
                indicatorColor: secondary_color,
                indicatorWeight: 3.5,
                labelColor: third_color,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Ongoing",
                  ),
                  Tab(
                    text: "Past",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RequestsPage(
                    ongoing: true,
                  ),
                  RequestsPage(
                    ongoing: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
