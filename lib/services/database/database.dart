import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart' hide User;
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

  FutureVoid createProduct({required Product product}) async {
    final productDoc = FirebaseFirestore.instance.collection("products").doc(product.productId);
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

  Future<void> createOrder(Order order) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(order.orderId)
        .set(order.toMap());

    // Now fetch the document to confirm its data or use it for further processing
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
    final cartItemDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(cartItem.userId)
        .collection("cart")
        .doc();
    await cartItemDoc.set(cartItem.toMap());
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

  Future<Product?> getProductById(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    if (doc.exists) {
      return Product.fromMap(doc.data()!);
    } else {
      return null;
    }
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

  Stream<List<Product>> getAllProducts() {
    try {
      final productDoc = _fire.collection("products");
      return productDoc
          .snapshots()
          .map((snaps) => snaps.docs.map((doc) => Product.fromMap(doc.data())).toList());
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
