import 'package:drp_basket_app/components/input_textfield.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../home_page.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "RegisterScreen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    implements AuthViewInterface {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email = "";
  String password1 = "";
  String password2 = "";
  bool showSpinner = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController1 = new TextEditingController();
  TextEditingController passwordController2 = new TextEditingController();

  void clearUIFields() {
    email = "";
    password1 = "";
    password2 = "";
    emailController.clear();
    passwordController1.clear();
    passwordController2.clear();
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
  void updateUIPasswordsNotMatch() {
    // TODO: implement updateUIPasswordsNotMatch
  }

  @override
  void updateUISuccess() {
    clearUIFields();
    Navigator.pushNamed(context, HomePage.id);
  }

  @override
  void updateUICannotCreateUser() {
    // TODO: implement updateUICannotCreateUser
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: LOGO_HERO_TAG,
                  child: Container(
                    height: 200.0,
                    child: Image.asset(LOGO_IMAGE_PATH),
                  ),
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
                onChanged: (value) => password1 = value,
                controller: passwordController1,
                borderColor: border_color,
                textColor: text_color,
                obscureText: true,
              ),
              SizedBox(
                height: 8.0,
              ),
              InputTextField(
                text: PASSWORD_RE_INPUT_TEXT,
                onChanged: (value) => password2 = value,
                controller: passwordController2,
                borderColor: border_color,
                textColor: text_color,
                obscureText: true,
              ),
              SizedBox(
                height: 24.0,
              ),
              LongButton(
                text: REGISTER_TEXT,
                onPressed: () => locator<UserController>()
                    .registerWithEmailAndPassword(
                        this, email, password1, password2),
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
