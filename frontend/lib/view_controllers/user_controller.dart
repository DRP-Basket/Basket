import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_auth_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/view_controllers/image_picker_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';

class UserController {
  late UserCredential _currentUser;
  FirebaseAuthInterface _firebaseAuthController =
      locator<FirebaseAuthInterface>();
  FirebaseStorageInterface _firebaseStorageController =
      locator<FirebaseStorageInterface>();
  FirebaseFirestoreInterface _firebaseFirestoreController =
      locator<FirebaseFirestoreInterface>();

  UserController();

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
        if (e.code == "email-already-in-use") {
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

  void uploadUserInformation(AuthViewInterface registerScreen,
      UserType userType, String name, String contactNumber,
      {containsImage = true, address = ""}) async {
    registerScreen.updateUILoading();
    if (containsImage) {
      File image = locator<ImagePickerController>().getImage();
      String destination =
          cloudProfileFilePath[userType]! + "${_currentUser.user!.uid}";
      try {
        await _firebaseStorageController.uploadFile(destination, image);
      } catch (exception) {
        print(exception);
      } finally {
        registerScreen.resetSpinner();
      }
    } else {
      assert(userType == UserType.RECEIVER);
    }

    try {
      await _firebaseFirestoreController.addNewUserInformation(
          userType, _currentUser.user!.uid, name, contactNumber,
          location: address);
      registerScreen.updateUISuccess();
    } catch (exception) {
      print(exception);
    } finally {
      registerScreen.resetSpinner();
    }
  }

  Future<UserType> checkUserType() async {
    return _firebaseFirestoreController.getUserType(_currentUser.user!.uid);
  }

  Future<List<Map<String, dynamic>>> getUserOrderAgainList() async {
    return await _firebaseFirestoreController
        .getOrderAgainList(_currentUser.user!.uid);
  }

  Future<void> userSignOut() {
    return _firebaseAuthController.signOut();
  }

  User? curUser() => _firebaseAuthController.curUser();

  Future<DocumentSnapshot<Map<String, dynamic>>> donorFromID(String id) =>
      _firebaseFirestoreController.donorFromID(id);

  loadFromStorage(BuildContext context, String image) =>
      _firebaseStorageController.loadFromStorage(image);
}
