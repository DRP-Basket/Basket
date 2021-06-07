import 'package:drp_basket_app/firebase_controllers/firebase_auth_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  late UserCredential _currentUser;
  FirebaseAuthController firebaseAuthController;
  UserController(this.firebaseAuthController);

  Future<void> registerWithEmailAndPassword(AuthViewInterface loginScreen, String email, String password1, String password2) async {
    loginScreen.updateUILoading();
    if (email == "" || password1 == "" || password2 == "") {
      loginScreen.updateUITextNoFilled();
    } else if (password1 != password2) {
      loginScreen.updateUIPasswordsNotMatch();
    } else {
      email = email.trim();
      try {
        _currentUser = await firebaseAuthController.createUserWithEmailAndPassword(email, password1);
        print(_currentUser.user!.email);
      } catch (exception) {
        loginScreen.updateUICannotCreateUser();
      }
      loginScreen.updateUISuccess();
    }
  }

  void logInWithEmailAndPassword(AuthViewInterface loginScreen, String email, String password) async {
    loginScreen.updateUILoading();
    if (email == "" || password == "") {
      loginScreen.updateUITextNoFilled();
    } else {
      email = email.trim();
      try {
        _currentUser = await firebaseAuthController.loginWithEmailAndPassword(email, password);
        print(_currentUser.user!.email);
      } catch (exception) {
        loginScreen.updateUINoUser();
      }
      loginScreen.updateUISuccess();
    }
  }
}