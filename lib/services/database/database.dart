import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shopify/models/cart_item.dart';
import 'package:shopify/models/order.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/models/user.dart';

typedef FutureVoid = Future<void>;
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _fire = FirebaseFirestore.instance;

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

  Future<String> fetchUsername(String id) async {
    final usernameDoc = await _fire.collection("users").doc(id).get();
    return usernameDoc.data()!['username'];
  }

  Future<void> createProduct({
    required Product product,
    required List<File> imageFiles,
  }) async {
    try {
      final productDoc = FirebaseFirestore.instance
          .collection("products")
          .doc(product.productId);
      final productId = productDoc.id;

      final imageUrls = await uploadProductImages(
        productId: productId,
        imageFiles: imageFiles,
      );
      final newProd = Product(
        quantity: product.quantity,
        productId: productDoc.id,
        ownerId: product.ownerId,
        title: product.title,
        description: product.description,
        price: product.price,
        category: product.category,
        isAvailable: product.isAvailable,
        datePosted: DateTime.now(),
        imageUrls: imageUrls,
      );
      await productDoc.set(newProd.toMap());
      log(newProd.toString());
    } on Exception catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<List<String>> uploadProductImages({
    required String productId,
    required List<File> imageFiles,
  }) async {
    try {
      final storage = FirebaseStorage.instance;
      List<String> downloadUrls = [];
      final uid = FirebaseAuth.instance.currentUser!.uid;
      for (int i = 0; i < imageFiles.length; i++) {
        final ref =
            storage.ref().child('products/$uid/$productId/image_$i.jpg');

        final uploadTask = await ref.putFile(imageFiles[i]);

        final url = await uploadTask.ref.getDownloadURL();

        downloadUrls.add(url);
      }
      return downloadUrls;
    } on Exception catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> createOrder(Order order) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(order.orderId)
        .set(order.toMap());

    final productDoc = await FirebaseFirestore.instance
        .collection("orders")
        .doc(order.orderId)
        .get();

    // Now you can work with productDoc and its data
    final productData = productDoc.data()!;
    final orderItem = Order(
      orderId: order.orderId,
      buyerId: order.buyerId,
      sellerId: order.sellerId,
      items: List.from(productData['items'] ?? []),
      totalAmount: productData['totalAmount'],
      status: order.status,
      orderDate: productData['orderDate'],
      deliveryAddress: productData['deliveryAddress'],
    );

    await productDoc.reference.set(orderItem.toMap());
  }

  Future addToCart(CartItem cartItem) async {
    try {
      return _fire
          .collection("users")
          .doc(cartItem.userId)
          .collection("cart")
          .doc(cartItem.cartItemId)
          .set(
            cartItem.toMap(),
          );
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future updateCartItem(CartItem cartItem) async {
    try {
      final updateDoc = _fire
          .collection("users")
          .doc(cartItem.userId)
          .collection("cart")
          .doc(cartItem.cartItemId);
      await updateDoc.update(cartItem.toMap());
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<List<CartItem>> readCartItems(String uid) async {
    final cartItemDoc =
        await _fire.collection("users").doc(uid).collection("cart").get();
    return cartItemDoc.docs
        .map(
          (doc) => CartItem.fromMap(doc.data()),
        )
        .toList();
  }

  Future<int> getcartQuantity(String productId) async {
    final cartItemDoc = await _fire
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("cart")
        .where('productId', isEqualTo: productId)
        .get();
    if (cartItemDoc.docs.isNotEmpty) {
      return cartItemDoc.docs.first.data()['quantity'] ?? 0;
    }
    return 0;
  }

  Future<List<CartItem>> loadCartItems() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .get();
    return snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
  }

  Future updateProduct(Product product) async {
    final updatedProd = product.copyWith(
      productId: product.productId,
      ownerId: product.ownerId,
      title: product.title,
      description: product.description,
      price: product.price,
      category: product.category,
      isAvailable: product.isAvailable,
      datePosted: product.datePosted,
      imageUrls: product.imageUrls,
    );
    final productDoc = FirebaseFirestore.instance
        .collection("products")
        .doc(product.productId);
    await productDoc.update(updatedProd.toMap());
  }

  Future deleteProduct(Product product) async {
    final productDoc = FirebaseFirestore.instance
        .collection("products")
        .doc(product.productId);
    await productDoc.delete();
  }

  Stream<List<Product>> getProductsByUser(String userId) {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection("products")
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => Product.fromMap(doc.data()),
            )
            .toList());
  }

  Future<Product> getProductById(String productId) async {
    final productDoc = await _fire.collection("products").doc(productId).get();
    return Product.fromMap(productDoc.data()!);
  }

  Stream<List<Product>> getAllProducts() {
    try {
      if (_auth.currentUser == null) {
        return Stream.value([]);
      }
      final productDoc = _fire.collection("products");
      return productDoc.snapshots().map((snaps) =>
          snaps.docs.map((doc) => Product.fromMap(doc.data())).toList());
    } on Exception catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<User> getOwnerByProductId(String id) async {
    final doc = await _fire.collection("users").doc(id).get();
    return User.fromMap(doc.data()!);
  }
}
