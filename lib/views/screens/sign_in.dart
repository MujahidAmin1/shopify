import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/authprovider.dart';
import 'package:shopify/views/screens/signup.dart';
import 'package:shopify/views/widgets/google_signin_button.dart';
import 'package:shopify/utils/ktextStyle.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

late TextEditingController emailController;
late TextEditingController passwordController;

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
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
            children: [
              const SizedBox(height: 30),
              Text("Sign In", style: kTextStyle(size: 40)),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                cursorColor: const Color(0xff8E6CEF),
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                cursorColor: const Color(0xff8E6CEF),
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              authProvider.isLoading
                  ? const Center(
                      child: SpinKitSpinningLines(color: Colors.black))
                  : FilledButton(
                      onPressed: () {
                        authProvider.signIn(
                          context,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(400, 50),
                        backgroundColor: const Color(0xff8E6CEF),
                      ),
                      child: Text(
                        'Sign In',
                        style: kTextStyle(size: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
              GoogleSigninButton(text: "Continue with Google"),
              const SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()),
                            );
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
