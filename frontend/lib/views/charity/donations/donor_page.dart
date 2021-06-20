import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/old/donor_request_end.dart';
import 'package:drp_basket_app/views/charity/old/utilities.dart';
import 'package:drp_basket_app/views/charity/requests/requests_page.dart';
import 'package:drp_basket_app/views/general/donor.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'donations_page.dart';

// Page displaying information related to a specific donor, ping donor from here

class DonorPage extends StatefulWidget {
  const DonorPage({Key? key}) : super(key: key);

  @override
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late Donor donorModel;
  late List<dynamic> reqIDs;
  late bool canSendReq;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    canSendReq = false;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _index,
    );
    donorModel = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(donorModel.name),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DonorPageUtilities.introRow(donorModel),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.25),
                  bottom: BorderSide(color: Colors.grey, width: 0.25),
                ),
              ),
              child: TabBar(
                onTap: (val) => {_index = val},
                controller: _tabController,
                indicatorColor: secondary_color,
                indicatorWeight: 3.5,
                labelColor: third_color,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: "Donations Available"),
                  Tab(text: "Requests"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Changed here
                  CharityDonationsPage(donorID: donorModel.uid),
                  RequestsPage(donorID: donorModel.uid),
                  // To here
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondary_color,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are you sure you want to send a donation request?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await Request.sendRequest(donorID: donorModel.uid);
                  ;
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
        label: Text("Send request"),
      ),
    );
  }
}
