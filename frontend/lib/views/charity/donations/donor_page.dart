import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/charity/old/utilities.dart';
import 'package:drp_basket_app/views/charity/requests/requests_page.dart';
import 'package:drp_basket_app/views/general/donor.dart';
import 'package:drp_basket_app/views/general/request.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  bool _uploading = false;

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
      body: !_uploading
          ? Container(
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
                        CharityDonationsPage(false, donorID: donorModel.uid),
                        RequestsPage(donorID: donorModel.uid),
                        // To here
                      ],
                    ),
                  ),
                ],
              ),
            )
          : loading(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondary_color,
        onPressed: () => showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => AlertDialog(
            title: Text("Are you sure you want to send a donation request?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _uploading = true;
                  });
                  Navigator.pop(context);
                  await Request.sendRequest(donorID: donorModel.uid);
                  await _requestSuccess();
                  setState(() {
                    _uploading = false;
                    _index = 1;
                    _tabController.index = 1;
                  });
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

  Future<bool?> _requestSuccess() {
    return Alert(
        context: context,
        title: "Success",
        desc: "Request sent",
        type: AlertType.success,
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: primary_color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]).show();
  }
}
