import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthInterface {
  loginWithEmailAndPassword(String email, String password) {}
  createUserWithEmailAndPassword(String email, String password) {}
  forgotPassword(String email) {}
  signOut() {}
  User? curUser() {}
}
