import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/cartprovider.dart';
import 'package:shopify/services/database/database.dart';

import '../../models/order.dart';

class PaymentServices {
  String publicKey = "pk_test_8fa202b27f8319126bb7015afedcec7721083dad";
  DatabaseService _service = DatabaseService();

  Future<Order?> makePayment(
      BuildContext context, String email, double amount, Order order) async {
    final txRef = PayWithPayStack().generateUuidV4();
    Order? updatedOrder;
    final Completer<Order> completer = Completer();

    PayWithPayStack().now(
        context: context,
        secretKey: "sk_test_1a6ba59fa15eb7ef440bf61ccea3280522fa7aed",
        customerEmail: email,
        reference: txRef,
        callbackUrl: "https://google.com",
        currency: 'NGN',
        amount: amount,
        transactionCompleted: (paymentData) async {
          log(paymentData.toString());
          var updatedOrder =
              order.copyWith(paymentId: txRef, status: OrderStatus.paid);
          await _service.createOrder(updatedOrder);
          Provider.of<Cartprovider>(context, listen: false).clearCart(FirebaseAuth.instance.currentUser!.uid);
          completer.complete(updatedOrder);
        },
        transactionNotCompleted: (e) {
          
          log(e.toString());
          completer.complete(updatedOrder);
        });
    return completer.future;
  }
}
