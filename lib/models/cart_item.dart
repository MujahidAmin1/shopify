import 'package:cloud_firestore/cloud_firestore.dart';
class CartItem {
  String productId;
  String userId;
  String cartItemId;
  DateTime addedAt;
  CartItem({
    required this.userId,
    required this.productId,
    required this.cartItemId,
    required this.addedAt,
  });
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      cartItemId: map['cartItemId'] ?? '',
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'cartItemId': cartItemId,
      'addedAt': addedAt,
    };
  }
}
