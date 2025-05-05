import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Column(
        spacing: 10,
        children: [
          Text("Sign Up"),
          
        ],
      ),
    );
  }
}
