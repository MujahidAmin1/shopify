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
class OrderItem {
  final String itemId;
  final String productId;
  final String productTitle;
  final String sellerId;
  final double price;
  final int quantity;
  final String snapshotImage;

  OrderItem({
    required this.itemId,
    required this.productId,
    required this.productTitle,
    required this.sellerId,
    required this.price,
    required this.quantity,
    required this.snapshotImage,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemId: map['itemId'],
      productId: map['productId'],
      productTitle: map['productTitle'],
      sellerId: map['sellerId'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      snapshotImage: map['snapshotImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'productId': productId,
      'productTitle': productTitle,
      'sellerId': sellerId,
      'price': price,
      'quantity': quantity,
      'snapshotImage': snapshotImage,
    };
  }
}
