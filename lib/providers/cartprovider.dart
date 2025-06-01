import 'package:flutter/material.dart';
import 'package:shopify/models/cart_item.dart';
import 'package:shopify/services/database/database.dart';

class Cartprovider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<CartItem> get items => _cartItems;
  DatabaseService service = DatabaseService();

  int getQuantity(String productId) {
    final matchingItems =
        _cartItems.where((item) => item.productId == productId);
    if (matchingItems.isNotEmpty) {
      return matchingItems.first.quantity;
    }
    return 0;
  }

  Future<void> fetchCartItems() async {
    _cartItems = await service.loadCartItems();
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    await service.addToCart(item);
    _cartItems.add(item);
    notifyListeners();
  }

  Future<void> updateCart(CartItem cartItem) async {
    await service.updateCartItem(cartItem);
    _cartItems = _cartItems
        .map((item) => item.cartItemId == cartItem.cartItemId ? cartItem : item)
        .toList();
    notifyListeners();
  }

  String? getCartItemId(String productId) {
    final matchingItems =
        _cartItems.where((item) => item.productId == productId);
    if (matchingItems.isNotEmpty) {
      return matchingItems.first.cartItemId;
    }
    return null;
  }

  Future<void> loadCartItems(String uid) async {
    _cartItems = await service.readCartItems(uid);
    notifyListeners();
  }
}
