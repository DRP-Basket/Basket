import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/charity/charity_donor.dart';
import 'package:flutter/material.dart';

class DonorPageUtilities {
  static Widget introRow(DonorModel donorModel) {
    return Row(
      children: [
        Spacer(),
        Expanded(
          flex: 30,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: CircleAvatar(
                backgroundImage: donorModel.image,
                radius: 75,
              ),
            ),
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 35,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donorModel.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    '${donorModel.address}',
                    style: TextStyle(
                      color: third_color,
                    ),
                  ),
                ),
                Text(
                  '${donorModel.contactNumber}',
                  style: TextStyle(
                    color: third_color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String getTimeString(Timestamp time) {
    List<String> timeStrings =
        DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch)
            .toString()
            .split(':');
    return timeStrings[0] + ':' + timeStrings[1];
  }
}
