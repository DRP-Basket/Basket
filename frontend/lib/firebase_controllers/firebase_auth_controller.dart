import 'package:drp_basket_app/firebase_controllers/firebase_auth_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthController implements FirebaseAuthInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuthController();

  Future<UserCredential> loginWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> forgotPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  String curUserEmail() => _auth.currentUser!.email!;

}