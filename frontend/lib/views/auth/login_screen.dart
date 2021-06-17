import 'package:drp_basket_app/components/input_textfield.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/view_controllers/validator_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:drp_basket_app/views/charity/events/charity_events_page.dart';
import 'package:drp_basket_app/views/donor/donor_main.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants.dart';
import '../../locator.dart';
import '../../user_type.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements AuthViewInterface {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  String email = "";
  String password = "";

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void login() {
    if (_formKey.currentState!.validate()) {
      locator<UserController>()
          .logInWithEmailAndPassword(this, email, password);
    }
  }

  @override
  void updateUILoading() {
    setState(() {
      showSpinner = true;
    });
  }

  @override
  void resetSpinner() {
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void updateUISuccess() async {
    email = "";
    password = "";
    emailController.clear();
    passwordController.clear();
    // Navigator.pushNamed(context, HomePage.id);
    UserType userType = await locator<UserController>().checkUserType();
    userType == UserType.CHARITY
        ? Navigator.pushNamedAndRemoveUntil(
            context, CharityEventsPage.id, (route) => false)
        : Navigator.pushNamedAndRemoveUntil(
            context, DonorMain.id, (route) => false);
  }

  @override
  void updateUIAuthFail(String title, String errmsg) {
    Alert(
        context: context,
        title: title,
        desc: errmsg,
        type: AlertType.warning,
        buttons: [
          DialogButton(
            child: Text(
              "Try Again",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.deepOrange,
            onPressed: () => Navigator.pop(context),
          ),
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 100,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: LOGO_HERO_TAG,
                  child: Container(
                    height: 200.0,
                    child: Image.asset(LOGO_IMAGE_PATH),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputTextField(
                        text: EMAIL_INPUT_TEXT,
                        onChanged: (value) => email = value,
                        controller: emailController,
                        validator: (value) =>
                            ValidatorController.validateEmail(value),
                        borderColor: secondary_color,
                        textColor: text_color,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      InputTextField(
                        text: PASSWORD_INPUT_TEXT,
                        onChanged: (value) => password = value,
                        controller: passwordController,
                        validator: (value) =>
                            ValidatorController.validatePassword(value),
                        borderColor: secondary_color,
                        textColor: text_color,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  ),
                  child: Center(
                    child: Text(FORGOT_PASSWORD_TEXT,
                        style: TextStyle(
                          color: third_color,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                LongButton(
                  text: LOGIN_TEXT,
                  onPressed: login,
                  backgroundColor: primary_color,
                  textColor: Colors.white,
                ),
                LongButton(
                  text: BACK_TEXT,
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: primary_color,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
