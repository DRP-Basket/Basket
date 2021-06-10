import 'package:drp_basket_app/components/choice_button.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/views/auth/register_information_screen.dart';
import 'package:flutter/material.dart';

class RegisterChoiceScreen extends StatefulWidget {
  static const String id = "RegisterChoiceScreen";

  const RegisterChoiceScreen({Key? key}) : super(key: key);

  @override
  _RegisterChoiceScreenState createState() => _RegisterChoiceScreenState();
}

class _RegisterChoiceScreenState extends State<RegisterChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceButton(
                  icon: RESTAURANT_IMAGE_PATH,
                  text: "Donor",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterInformationScreen(
                        userType: UserType.DONOR,
                      ),
                    ),
                  ),
                ),
                ChoiceButton(
                  icon: RECEIVER_IMAGE_PATH,
                  text: "Receiver",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterInformationScreen(
                        userType: UserType.RECEIVER,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 100.0,
            // ),
            // ChoiceButton(
            //   icon: FOOD_BANK_IMAGE_PATH,
            //   text: "Food Bank",
            //   onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => RegisterInformationScreen(
            //         userType: UserType.FOOD_BANK,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
