import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopify/models/order.dart';
import 'package:shopify/services/database/database.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DatabaseService service = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: StreamBuilder<List<Order>>(
          stream: service.readOrderByUid(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            return Center(
              child: SpinKitSpinningLines(color: Colors.blue),
            );
          }),
    );
  }
}
