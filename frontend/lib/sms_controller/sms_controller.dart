import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:telephony/telephony.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';

class SMSController {
  final Telephony telephony = Telephony.instance;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRedeemCode(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String getRedeemURL(String uid, String donationID, String charityID) {
    String redeemCode = getRedeemCode(5);
    String url = "www.xxxxxx.com/redeem$redeemCode";
    locator<FirebaseFirestoreInterface>()
        .assignNewRedeemCode(redeemCode, uid, donationID, charityID);
    return url;
  }

  Future<bool> sendSMS(String donationID, {msgContent = ''}) async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted!) {
      List contacts =
          await locator<FirebaseFirestoreInterface>().getContactMap();
      var curUser = locator<UserController>().curUser()!;
      print(curUser);
      await locator<FirebaseFirestoreInterface>()
          .addContactToPending(donationID, contacts);
      for (DocumentSnapshot contactDS in contacts) {
        var contactInfo = (contactDS.data() as Map<String, dynamic>);
        String redemptionLink =
            "Please click on the link ${getRedeemURL(contactDS.id, donationID, curUser.uid)} when you collect your food.";
        telephony.sendSms(
            to: contactInfo["contact"],
            message: msgContent + '\n' + redemptionLink);
      }
      return true;
    }
    return false;
  }
}
