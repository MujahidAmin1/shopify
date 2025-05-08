import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:shopify/models/user.dart';
import 'package:shopify/services/auth/auth.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/views/screens/home.dart';

class Authprovider extends ChangeNotifier {
  bool isLoading = false;
  AuthService _auth = AuthService();
  DatabaseService databaseService = DatabaseService();
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future signIn(BuildContext context, String email, String password) async {
    try {
      setLoading(true);
      await _auth.signIn(email, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MyHomePage();
          },
        ),
      );
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future signOut(BuildContext context) async {
    try {
      setLoading(true);
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future createAcct(String username, String email, String password) async {
    try {
      setLoading(true);
      await _auth.createAcct(username, email, password);
      await databaseService.createUser(User(
          email: email,
          username: username,
          id: FirebaseAuth.instance.currentUser!.uid));
      await _auth.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'Email already exists';
      }
    } finally {
      setLoading(false);
    }
  }
}
