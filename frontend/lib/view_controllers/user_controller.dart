import 'package:drp_basket_app/firebase_controllers/firebase_auth_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/view_controllers/image_picker_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class UserController {
  late UserCredential _currentUser;
  FirebaseAuthInterface _firebaseAuthController;
  FirebaseStorageInterface _firebaseStorageController;
  FirebaseFirestoreInterface _firebaseFirestoreController;

  UserController(this._firebaseAuthController, this._firebaseStorageController, this._firebaseFirestoreController);

  final String _registrationFailed = "Registration failed";

  Future<void> registerWithEmailAndPassword(AuthViewInterface registerScreen,
      String email, String password1, String password2) async {
    registerScreen.updateUILoading();
    if (password1 != password2) {
      registerScreen.updateUIAuthFail(
          "Mismatched passwords", "Please retype your passwords.");
      registerScreen.resetSpinner();
    } else {
      email = email.trim();
      try {
        _currentUser = await _firebaseAuthController
            .createUserWithEmailAndPassword(email, password1);
        // print(_currentUser.user!.email);
        registerScreen.updateUISuccess();
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          registerScreen.updateUIAuthFail(_registrationFailed,
              "The password must be at least 6 characters.");
        } else if (e.code == "email-already-in-use") {
          registerScreen.updateUIAuthFail(
              _registrationFailed, "An account already exists for that email.");
        } else if (e.code == "invalid-email") {
          registerScreen.updateUIAuthFail(
              _registrationFailed, "Please enter a valid email address.");
        }
      } finally {
        registerScreen.resetSpinner();
      }
    }
  }

  final String _loginFailed = "Login failed";

  void logInWithEmailAndPassword(
      AuthViewInterface loginScreen, String email, String password) async {
    loginScreen.updateUILoading();
    email = email.trim();
    try {
      _currentUser = await _firebaseAuthController.loginWithEmailAndPassword(
          email, password);
      loginScreen.updateUISuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        loginScreen.updateUIAuthFail(
            _loginFailed, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        loginScreen.updateUIAuthFail(
            _loginFailed, "Password input is incorrect.");
      }
    } finally {
      loginScreen.resetSpinner();
    }
  }

  void forgotPassword(email) async {
    await _firebaseAuthController.forgotPassword(email);
  }

  void uploadUserInformation(AuthViewInterface registerScreen, UserType userType, String name, String contactNumber) async {
    registerScreen.updateUILoading();
    File image = locator<ImagePickerController>().getImage();
    String destination = cloudFilePath[userType]! + "profile/${_currentUser.user!.uid}";

    try {
      await _firebaseFirestoreController.addNewUserInformation(_currentUser.user!.uid, name, contactNumber);
      print(destination);
      await _firebaseStorageController.uploadFile(destination, image);
      registerScreen.updateUISuccess();
    } catch (exception) {
      registerScreen.resetSpinner();
      print(exception);
    }
  }
}
