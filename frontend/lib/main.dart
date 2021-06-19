import 'package:drp_basket_app/views/auth/register_choice_screen.dart';
import 'package:drp_basket_app/views/charity/events/charity_events_page.dart';
import 'package:drp_basket_app/views/charity/receivers/charity_receivers.dart';
import 'package:drp_basket_app/views/donor/statistics/donor_stats_screen.dart';
import 'package:drp_basket_app/views/donor/donor_profile_page.dart';
import 'package:drp_basket_app/views/home_page.dart';
import 'package:drp_basket_app/views/auth/login_screen.dart';
import 'package:drp_basket_app/views/auth/register_screen.dart';
import 'package:drp_basket_app/views/welcome_page.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'locator.dart';
import 'views/charity/donations/donations_main.dart';
import 'views/donor/donor_main.dart';

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
      home: WelcomeScreen(),
      routes: {
        // General
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        // Donor
        DonorStatsPage.id: (context) => DonorStatsPage(),
        RegisterChoiceScreen.id: (context) => RegisterChoiceScreen(),
        DonorProfilePage.id: (context) => DonorProfilePage(),
        DonorMain.id: (context) => DonorMain(),
        // Charity
        CharityEventsPage.id: (context) => CharityEventsPage(),
        ReceiversList.id: (context) => ReceiversList(),
        DonationsMain.id: (context) => DonationsMain(),
      },
    );
  }
}
