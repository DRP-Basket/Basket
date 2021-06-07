import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import 'home_page.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "RegisterScreen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email = "";
  String password1 = "";
  String password2 = "";
  bool showSpinner = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController1 = new TextEditingController();
  TextEditingController passwordController2 = new TextEditingController();

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
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  email = value;
                },
                controller: emailController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black54),
                  hintText: 'Enter your email',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                controller: passwordController1,
                onChanged: (value) {
                  password1 = value;
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black54),
                  hintText: 'Enter your password.',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                controller: passwordController2,
                onChanged: (value) {
                  password2 = value;
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black54),
                  hintText: 'Re-enter your password.',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: primary_color,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      if (email == "" || password1 == "" || password2 == "") {
                        // alert;
                      } else if (password1 != password2) {
                        // alert not same password
                      } else {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          email = email.trim();
                          UserCredential user =
                          await _firebaseAuth.createUserWithEmailAndPassword(
                              email: email, password: password1);
                          print(user);
                          Navigator.pushNamed(context, HomePage.id);
                        } catch (exception) {
                          print(exception);
                        } finally {
                          emailController.clear();
                          passwordController1.clear();
                          passwordController2.clear();
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                    ),
                  ),
                ),
              ),
              Material(
                color: primary_color,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Back',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}