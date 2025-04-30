import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String orderId;
  final String productId;
  final String buyerId;
  final String sellerId;
  final DateTime orderDate;
  final String status; // e.g. 'pending', 'shipped', 'completed'

  Order({
    required this.orderId,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.orderDate,
    required this.status,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      productId: map['productId'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'orderDate': orderDate,
      'status': status,
    };
  }
}
