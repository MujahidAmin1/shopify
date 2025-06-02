import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/views/widgets/custom_cart_tile.dart';
import 'package:intl/intl.dart';

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
      body: FutureBuilder(
          future: service.readCartItems(_auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("User not found."));
            } else {
              final cartItems = snapshot.data!;
              return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future:
                          service.getProductById(cartItems[index].productId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text("User not found."));
                        } else {
                          final product = snapshot.data;
                          String formattedPrice = NumberFormat.currency(
                            locale:
                                'en_NG',
                            symbol: '₦',
                          ).format(product!.price);
                          return CustomProductTile(
                            title: product.title,
                            imageUrl: product.imageUrls.first,
                            trailing: Text("${cartItems[index].quantity}"),
                            subtitle: formattedPrice,
                          );
                        }
                      },
                    );
                  });
            }
          }),
    );
  }
}
