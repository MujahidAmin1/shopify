import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: Center(
        child: SpinKitSpinningLines(color: Colors.blue),
      ),
    );
  }
}