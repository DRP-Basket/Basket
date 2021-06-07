import 'package:drp_basket_app/components/input_textfield.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../constants.dart';
import '../../locator.dart';
import '../home_page.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements AuthViewInterface {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool showSpinner = false;

  String email = "";
  String password = "";

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void clearUIFields() {
    email = "";
    password = "";
    emailController.clear();
    passwordController.clear();
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void updateUILoading() {
    setState(() {
      showSpinner = true;
    });
  }

  @override
  void updateUINoUser() {
    // TODO: implement updateUINoUser
  }

  @override
  void updateUITextNotFilled() {
    // TODO: implement updateUITextNoFilled
  }

  @override
  void updateUIPasswordsNotMatch() {}

  @override
  void updateUISuccess() {
    clearUIFields();
    Navigator.pushNamed(context, HomePage.id);
  }

  @override
  void updateUICannotCreateUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
              SizedBox(
                height: 48.0,
              ),
              InputTextField(
                text: EMAIL_INPUT_TEXT,
                onChanged: (value) => email = value,
                controller: emailController,
                borderColor: border_color,
                textColor: text_color,
              ),
              SizedBox(
                height: 8.0,
              ),
              InputTextField(
                text: PASSWORD_INPUT_TEXT,
                onChanged: (value) => password = value,
                controller: passwordController,
                borderColor: border_color,
                textColor: text_color,
                obscureText: true,
              ),
              SizedBox(
                height: 24.0,
              ),
              LongButton(
                text: LOGIN_TEXT,
                onPressed: () => locator<UserController>()
                    .logInWithEmailAndPassword(this, email, password),
                backgroundColor: primary_color,
                textColor: text_color,
              ),
              LongButton(
                text: BACK_TEXT,
                onPressed: () => Navigator.pop(context),
                backgroundColor: primary_color,
                textColor: text_color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
