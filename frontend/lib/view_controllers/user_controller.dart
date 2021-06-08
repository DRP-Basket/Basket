import 'package:drp_basket_app/firebase_controllers/firebase_auth_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  late UserCredential _currentUser;
  FirebaseAuthController firebaseAuthController;

  UserController(this.firebaseAuthController);

  final String _registrationFailed = "Registration failed";

  Future<void> registerWithEmailAndPassword(AuthViewInterface loginScreen,
      String email, String password1, String password2) async {
    loginScreen.updateUILoading();
    if (password1 != password2) {
      loginScreen.updateUIAuthFail(
          "Mismatched passwords", "Please retype your passwords.");
      loginScreen.resetSpinner();
    } else {
      email = email.trim();
      try {
        _currentUser = await firebaseAuthController
            .createUserWithEmailAndPassword(email, password1);
        // print(_currentUser.user!.email);
        loginScreen.updateUISuccess();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          loginScreen.updateUIAuthFail(_registrationFailed,
              "The password must be at least 6 characters.");
        } else if (e.code == 'email-already-in-use') {
          loginScreen.updateUIAuthFail(
              _registrationFailed, "An account already exists for that email.");
        }
      } finally {
        loginScreen.resetSpinner();
      }
    }
  }

  final String _loginFailed = "Login failed";

  void logInWithEmailAndPassword(
      AuthViewInterface loginScreen, String email, String password) async {
    loginScreen.updateUILoading();
    email = email.trim();
    try {
      _currentUser = await firebaseAuthController.loginWithEmailAndPassword(
          email, password);
      // print(_currentUser.user!.email);
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
    await firebaseAuthController.forgotPassword(email);
  }
}
