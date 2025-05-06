import 'package:cloud_firestore/cloud_firestore.dart';

OrderStatus orderStatusFromString(String status) {
  return OrderStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => OrderStatus.pending,
  );
}

String orderStatusToString(OrderStatus status) => status.name;

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
  completed,
}

class Order {
  final String orderId;
  final String buyerId;
  final String sellerId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status; // pending, shipped, delivered, etc.
  final DateTime orderDate;
  final String deliveryAddress;
  final String? paymentId; // from gateway (e.g., Stripe)
  final bool isDeliveryConfirmed;
  final DateTime? deliveredAt;

  Order({
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    this.paymentId,
    this.isDeliveryConfirmed = false,
    this.deliveredAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      items: (map['items'] as List)
          .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: orderStatusFromString(map['status']),
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      deliveryAddress: map['deliveryAddress'],
      paymentId: map['paymentId'],
      isDeliveryConfirmed: map['isDeliveryConfirmed'] ?? false,
      deliveredAt: map['deliveredAt'] != null
          ? (map['deliveredAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': orderStatusToString(status),
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryAddress': deliveryAddress,
      'paymentId': paymentId,
      'isDeliveryConfirmed': isDeliveryConfirmed,
      'deliveredAt':
          deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
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

  double get subtotal => price * quantity;

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemId: map['itemId'],
      productId: map['productId'],
      productTitle: map['productTitle'],
      sellerId: map['sellerId'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
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
