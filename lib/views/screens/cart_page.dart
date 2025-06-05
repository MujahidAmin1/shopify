import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/cartprovider.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/price_format.dart';
import 'package:shopify/views/widgets/custom_cart_tile.dart';
import 'package:intl/intl.dart';
import 'package:shopify/views/widgets/order_summary_widget.dart';

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
    var cartProvider = Provider.of<Cartprovider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: cartProvider.cartItems.isEmpty
          ? Center(child: Text("No items in cart"))
          : FutureBuilder(
              future: service.readCartItems(_auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No data"));
                } else {
                  final cartItems = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                future: Future.wait(
                                  cartItems.map((item) =>
                                      service.getProductById(item.productId)),
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text("Error: ${snapshot.error}"));
                                  } else if (!snapshot.hasData) {
                                    return const Center(
                                        child: Text("User not found."));
                                  } else {
                                    final products = snapshot.data!;

                                    return CustomProductTile(
                                      title: products[index].title,
                                      imageUrl: products[index].imageUrls.first,
                                      trailing:
                                          Text("${cartItems[index].quantity}"),
                                      subtitle: formatNairaPrice(
                                          cartItems[index].price),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                      OrderSummarySection(
                        price: cartProvider.totalPrice,
                        quantity: cartProvider.totalQuantity,
                        onPlaceOrder: () {},
                      ),
                    ],
                  );
                }
              }),
    );
  }
}
