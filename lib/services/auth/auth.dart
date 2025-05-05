import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  void createAcct(String username, String email, String password) async {
    try {
      final credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(credentials.toString());
    } on FirebaseAuthException catch (e) {
      return log(e.toString());
    }
  }

  void signIn(String email, String password) async {
    try {
      final credentials =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(credentials.toString());
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }
}
