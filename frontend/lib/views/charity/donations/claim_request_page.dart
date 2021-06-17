import 'package:drp_basket_app/views/donor/donor.dart';
import 'package:flutter/material.dart';

import 'claim_request_form.dart';

class ClaimRequestPage extends StatefulWidget {

  final ClaimRequest request;
  final Donor donor;

  const ClaimRequestPage(this.request, this.donor, { Key? key }) : super(key: key);

  @override
  _ClaimRequestPageState createState() => _ClaimRequestPageState(request, donor);
}

class _ClaimRequestPageState extends State<ClaimRequestPage> {
  
  final ClaimRequest request;
  final Donor donor;

  _ClaimRequestPageState(this.request, this.donor);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('TODO : display appropriate donor info and claim request info'),
    );
  }
}