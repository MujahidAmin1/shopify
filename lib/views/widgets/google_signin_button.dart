import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/views/screens/home.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

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
          Navigator.pushReplacement(
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 40,
        child: Row(
          spacing: 10,
          children: [Image.asset('assets/Google.png'), Text(text)],
        ),
      ),
    );
  }
}
