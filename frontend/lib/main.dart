import 'package:drp_basket_app/views/donor/donor_home_page.dart';
import 'package:drp_basket_app/views/home_page.dart';
import 'package:drp_basket_app/views/auth/login_screen.dart';
import 'package:drp_basket_app/views/receivers/receiver_home_page.dart';
import 'package:drp_basket_app/views/auth/register_screen.dart';
import 'package:drp_basket_app/views/welcome_page.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServices();
  runApp(Basket());
}

class Basket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LOGO_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
      routes: {
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        DonorHomePage.id: (context) => DonorHomePage(),
        ReceiverHomePage.id: (context) => ReceiverHomePage(),
      },
    );
  }
}

