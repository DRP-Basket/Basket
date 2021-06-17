import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:flutter/material.dart';

import 'charity/events/charity_events_page.dart';
import 'donor/donor_main.dart';

class HomePage extends StatelessWidget {
  static const String id = "HomePage";

  HomePage({Key? key}) : super(key: key);

  // Future<void> getName() async {
  //   DocumentSnapshot ds = await locator<FirebaseFirestoreInterface>()
  //       .getCollection("testing")
  //       .doc("testing")
  //       .get();
  //   String name = (ds.data() as Map<String, dynamic>)["testing"];
  //   final user = _firebaseAuth.currentUser;
  //   if (user != null) {
  //     print(user.email);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LongButton(
          //   text: "Test Firebase Connection",
          //   onPressed: getName,
          //   backgroundColor: Colors.pinkAccent,
          //   textColor: Colors.white,
          // ),
          LongButton(
            text: "Donor",
            onPressed: () => {
              locator<UserController>().testLogInWithEmailAndPassword().then(
                  (value) =>
                      Navigator.pushReplacementNamed(context, DonorMain.id))
            },
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
          ),
          LongButton(
            text: "Charity",
            onPressed: () => {
              locator<UserController>()
                  .testLogInCharityWithEmailAndPassword()
                  .then((value) => Navigator.pushReplacementNamed(
                      context, CharityEventsPage.id))
            },
            backgroundColor: Colors.purpleAccent,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
