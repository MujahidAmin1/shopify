import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shopify/firebase_options.dart';
import 'package:shopify/providers/authprovider.dart';
import 'package:shopify/providers/btm_navbar_provider.dart';
import 'package:shopify/providers/product_provider.dart';
import 'package:shopify/views/screens/signup.dart';

import 'views/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Authprovider()),
    ChangeNotifierProvider(create: (_) => BtmNavbarProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: SpinKitSpinningLines(color: Colors.black));
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return MyHomePage();
          } else {
            return SignupPage();
          }
        },
      ),
    );
  }
}
