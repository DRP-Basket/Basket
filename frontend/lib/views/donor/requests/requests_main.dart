import 'package:drp_basket_app/views/donor/requests/requests_page.dart';
import 'package:flutter/material.dart';

class RequestsMain extends StatelessWidget {
  static String id = "CharityRequestsMain";

  const RequestsMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Incoming Requests'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Ongoing',
              ),
              Tab(
                text: 'Past',
              ),
            ],
          ),
        ),
        body: TabBarView(
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
    );
  }
}
