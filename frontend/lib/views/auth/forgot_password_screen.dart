import 'package:drp_basket_app/components/input_textfield.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/view_controllers/validator_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants.dart';



class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final String alertDescriptionMessage = "If your email is registered, you will get an email to reset your password.";
  final String emailSent = "Email Sent";

  bool showSpinner = false;
  String email = "";
  TextEditingController emailController = new TextEditingController();

  void forgotPassword(context) {
    if (_formKey.currentState!.validate()) {
      locator<UserController>().forgotPassword(email);
      Alert(
        context: context,
        title: emailSent,
        desc: alertDescriptionMessage,
        type: AlertType.success,
      ).show();
      emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
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
                SizedBox(
                  height: 24.0,
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
                        borderColor: border_color,
                        textColor: text_color,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                LongButton(
                  text: SEND_REQUEST_TEXT,
                  onPressed: () => forgotPassword(context),
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
      ),
    );
  }
}
