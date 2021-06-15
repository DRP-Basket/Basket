import 'package:drp_basket_app/views/auth/register_choice_screen.dart';
import 'package:drp_basket_app/views/charity/charity_donation_page.dart';
import 'package:drp_basket_app/views/charity/contact_list_page.dart';
import 'package:drp_basket_app/views/donor/dart_stats_screen.dart';
import 'package:drp_basket_app/views/donor/donor_home_page.dart';
import 'package:drp_basket_app/views/donor/donor_profile_page.dart';
import 'package:drp_basket_app/views/home_page.dart';
import 'package:drp_basket_app/views/auth/login_screen.dart';
import 'package:drp_basket_app/views/receivers/home_screen.dart';
import 'package:drp_basket_app/views/auth/register_screen.dart';
import 'package:drp_basket_app/views/welcome_page.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'locator.dart';
import 'views/charity/charity_home_page.dart';

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
          primaryColor: primary_color,
          timePickerTheme: TimePickerThemeData(
            dialHandColor: fourth_color,
            hourMinuteTextColor: third_color,
          )),
      home: HomePage(),
      routes: {
        // General
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        // Donor
        DonorHomePage.id: (context) => DonorHomePage(),
        DonorStatsPage.id: (context) => DonorStatsPage(),
        ReceiverHomeScreen.id: (context) => ReceiverHomeScreen(),
        RegisterChoiceScreen.id: (context) => RegisterChoiceScreen(),
        DonorProfilePage.id: (context) => DonorProfilePage(),
        // Receiver
        // ReceiverHomePage.id: (context) => ReceiverHomePage(),
        // Charity
        CharityHomePage.id: (context) => CharityHomePage(),
        CharityDonationPage.id: (context) => CharityDonationPage(),
        ContactListPage.id: (context) => ContactListPage(),
      },
    );
  }
}
