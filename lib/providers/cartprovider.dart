import 'package:flutter/foundation.dart';
import 'package:shopify/models/cart_item.dart';
import 'package:shopify/services/database/database.dart';

class Cartprovider with ChangeNotifier {
  final Map<String, int> _productQuantities = {};
  final List<CartItem> _cartItems = [];
  DatabaseService service = DatabaseService();

  Map<String, int> get productQuantities => _productQuantities;

  int getQuantity(String productId) => _productQuantities[productId] ?? 0;

  void addToCart(CartItem item) {
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);

  if (existingIndex >= 0) {
    _cartItems[existingIndex].quantity += 1;
  } else {
    _cartItems.add(item);
  }
    _productQuantities[item.productId] =
        (_productQuantities[item.productId] ?? 0) + 1;
    service.addToCart(item);
    notifyListeners();
  }
}
