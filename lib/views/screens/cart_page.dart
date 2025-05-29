import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopify/services/database/database.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DatabaseService service = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: service.readCartItems(_auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("User not found."));
            } else {
              final cartItems = snapshot.data!;
              return FutureBuilder(
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(cartItems[index].productId),
                          leading: Text("${cartItems[index].quantity}"),
                        );
                      });
                }
              );
            }
          }),
    );
  }
}
