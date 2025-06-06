import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String productId;
  String userId;
  int quantity;
  String cartItemId;
  DateTime addedAt;
  double price;
  CartItem({
    required this.userId,
    required this.productId,
    required this.cartItemId,
    required this.quantity,
    required this.price,
    required this.addedAt,
  });
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      cartItemId: map['cartItemId'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: map['price'] ?? 0,
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'price': price,
      'cartItemId': cartItemId,
      'quantity': quantity,
      'addedAt': addedAt,
    };
  }
}
