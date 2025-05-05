import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:shopify/models/cart_item.dart';
import 'package:shopify/models/order.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/models/user.dart';

typedef FutureVoid = Future<void>;

class DatabaseService {
  FutureVoid createUser(User user) async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection("users").doc(user.id);
      await userDoc.set(user.toMap());
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  FutureVoid createProduct(Product product) async {
    final productDoc = FirebaseFirestore.instance.collection("products").doc();
    final newProd = Product(
      productId: productDoc.id,
      ownerId: product.ownerId,
      title: product.title,
      description: product.description,
      price: product.price,
      category: product.category,
      isAvailable: product.isAvailable,
      datePosted: DateTime.now(),
      imageUrls: product.imageUrls,
    );
    await productDoc.set(newProd.toMap());
  }

  FutureVoid createOrder(Order order, String id) async {
    final orderDoc =
        FirebaseFirestore.instance.collection("orders").doc(order.orderId);
    await orderDoc.set(order.toMap());
  }

  Future addToCart(CartItem cartItem) async {
    final cartItemDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(cartItem.userId)
        .collection("cart")
        .doc();
    await cartItemDoc.set(cartItem.toMap());
  }
}
