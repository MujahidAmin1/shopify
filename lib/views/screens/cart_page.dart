import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/order.dart';
import 'package:shopify/providers/cartprovider.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/services/payment/payment_services.dart';
import 'package:shopify/utils/price_format.dart';
import 'package:shopify/views/widgets/custom_cart_tile.dart';
import 'package:shopify/views/widgets/order_summary_widget.dart';
import 'package:uuid/uuid.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DatabaseService service = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PaymentServices paymentService = PaymentServices();
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
                        onPlaceOrder: () async {
                          var order = Order(
                            orderId: Uuid().v4(),
                            buyerId: _auth.currentUser!.uid,
                            items: cartItems,
                            totalAmount: cartProvider.totalPrice,
                            status: OrderStatus.processing,
                            orderDate: DateTime.now(),
                            deliveryAddress: "deliveryAddress",
                          );
                          var makeOrder = await paymentService.makePayment(
                            context,
                            _auth.currentUser!.email!,
                            cartProvider.totalPrice,
                            order,
                          );
                          if (makeOrder!.status == OrderStatus.paid) {
                            Flushbar(
                              message: 'Payment Successful',
                              duration: const Duration(seconds: 6),
                              backgroundColor: Colors.green,
                              flushbarPosition: FlushbarPosition.TOP,
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.white),
                            ).show(context);
                          } else {
                            Flushbar(
                              message: 'Payment Failed',
                              duration: const Duration(seconds: 6),
                              backgroundColor: Colors.red,
                              flushbarPosition: FlushbarPosition.TOP,
                              icon:
                                  const Icon(Icons.error, color: Colors.white),
                            ).show(context);
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}
