import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future createAcct(String username, String email, String password) async {
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

  Future signIn(String email, String password) async {
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

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }
  }
}
