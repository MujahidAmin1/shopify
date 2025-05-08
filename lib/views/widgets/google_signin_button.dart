import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/views/screens/home.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
DatabaseService service = DatabaseService();

class GoogleSigninButton extends StatelessWidget {
  String text;
  GoogleSigninButton({
    super.key,
    required this.text,
  });
  FutureVoid _googleSignIn(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await _auth.signInWithCredential(GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken));
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MyHomePage();
              },
            ),
          );
        } on FirebaseAuthException catch (e) {
          throw FirebaseAuthException(code: e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _googleSignIn(context);
      },
      child: SizedBox(
        height: 55,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
          elevation: 4,
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Google.png'),
              Text(text, style: kTextStyle(size: 20, isBold: true)),
            ],
          ),
        ),
      ),
    );
  }
}
