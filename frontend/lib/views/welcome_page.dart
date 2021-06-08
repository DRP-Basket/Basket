import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/views/auth/register_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'auth/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: LOGO_HERO_TAG,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      child: Image.asset(LOGO_IMAGE_PATH),
                      height: 60.0,
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  child: Text(LOGO_NAME),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            LongButton(
              text: LOGIN_TEXT,
              onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
              backgroundColor: primary_color,
              textColor: text_color,
            ),
            LongButton(
              text: REGISTER_TEXT,
              onPressed: () => Navigator.pushNamed(context, RegisterScreen.id),
              backgroundColor: primary_color,
              textColor: text_color,
            ),
          ],
        ),
      ),
    );
  }
}
