import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopify/models/order.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/navigate.dart';
import 'package:shopify/utils/price_format.dart';
import 'package:shopify/views/widgets/reciept_widget.dart';

import '../../../models/cart_item.dart';
import '../../../models/product.dart';
import '../../../utils/ktextStyle.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitSpinningLines(color: Colors.black),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error!.toString(),
                style: kTextStyle(color: Colors.white),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No active orders'));
          } else {
            final orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return FutureBuilder(
                    future: fetchProductsForOrder(order),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(title: Text("Loading..."));
                      }

                      if (snapshot.hasError) {
                        return ListTile(
                            title: Text("Error"),
                            subtitle: Text(snapshot.error.toString()));
                      }
                      final prodData = snapshot.data!;
                      return GestureDetector(
                        onTap: () => context.push(ReceiptWidget(
                          order: orders[index],
                          prodData: prodData,
                        )),
                        child: ListTile(
                          title: Text(orders[index].items.length <= 1
                              ? '${orders[index].items.first}'
                              : '${orders[index].items.first.productTitle} + ${orders[index].items.length - 1} others'),
                          subtitle:
                              Text(formatNairaPrice(orders[index].totalAmount)),
                          trailing:
                              Text("Status: ${orders[index].status.name}"),
                        ),
                      );
                    });
              },
            );
          }
        },
      ),
    );
  }
}

Future<List<Product>> fetchProductsForOrder(Order order) async {
  List<Product> products = [];
  for (CartItem item in order.items) {
    Product product = await DatabaseService().getProductById(item.productId);
    products.add(product);
  }
  return products;
}
