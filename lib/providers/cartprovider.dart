import 'package:flutter/foundation.dart';
import 'package:shopify/models/cart_item.dart';

class Cartprovider with ChangeNotifier {
  final Map<String, int> _productQuantities = {};
  final List<CartItem> _cartItems = [];

  Map<String, int> get productQuantities => _productQuantities;

  int getQuantity(String productId) => _productQuantities[productId] ?? 0;

  void addToCart(CartItem item) {
    _cartItems.add(item);
    _productQuantities[item.productId] = (_productQuantities[item.productId] ?? 0) + 1;
    notifyListeners();
  }
}
