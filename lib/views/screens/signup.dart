import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/views/screens/sign_in.dart';
import 'package:shopify/views/widgets/google_signin_button.dart';
import 'package:shopify/providers/authprovider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

late TextEditingController usernameController;
late TextEditingController emailController;
late TextEditingController passwordController;

class _SignupPageState extends State<SignupPage> {
  @override
  void initState() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Authprovider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              const SizedBox(height: 30),
              Text("Sign Up", style: kTextStyle(size: 40)),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                cursorColor: Color(0xff8E6CEF),
                decoration: InputDecoration(
                  focusColor: Color(0xff8E6CEF),
                  hintText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextField(
                cursorColor: Color(0xff8E6CEF),
                controller: emailController,
                decoration: InputDecoration(
                  focusColor: Color(0xff8E6CEF),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextField(
                cursorColor: Color(0xff8E6CEF),
                controller: passwordController,
                decoration: InputDecoration(
                  focusColor: Color(0xff8E6CEF),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              authProvider.isLoading
                  ? Center(child: SpinKitSpinningLines(color: Colors.black))
                  : FilledButton(
                      onPressed: () {
                        authProvider.createAcct(
                          usernameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      style: FilledButton.styleFrom(
                          minimumSize: Size(400, 50),
                          backgroundColor: Color(0xff8E6CEF)),
                      child: Text(
                        'Sign Up',
                        style: kTextStyle(size: 20, color: Colors.white),
                      ),
                    ),
              GoogleSigninButton(text: "Continue with Google"),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Sign in',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle sign in tap
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return SignInPage();
                            }));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
