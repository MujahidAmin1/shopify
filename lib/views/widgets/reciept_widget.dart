import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopify/models/order.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/utils/copyable_text.dart';
import 'package:shopify/utils/price_format.dart';

class ReceiptWidget extends StatelessWidget {
  final Order order;
  final List<Product> prodData;
  const ReceiptWidget({super.key, required this.order, required this.prodData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order details"),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Material(
          elevation: 4,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          shadowColor: Colors.black26,
          child: ClipPath(
            clipper: BottomZigZagClipper(),
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // PalmPay header
                  Text(
                    'Order',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(thickness: 1),
                  buildItem('Tx ID', order.paymentId!.substring(0, 8),
                      isCopyable: true),
                  buildItem('buyerId', order.buyerId.substring(0, 8),
                      isCopyable: true),
                  buildItem('Amount', formatNairaPrice(order.totalAmount)),
                  buildItem('Status', order.status.name, isSuccess: true),
                  buildItem(
                      'Date', DateFormat('dd-MM-yy').format(order.orderDate)),
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),
                  buildItem('Items', 'Qty'),
                  ...order.items.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    final product = prodData[i];
                    return buildItem(product.title, '${item.quantity}');
                  }),

                  const Divider(thickness: 1),
                  const SizedBox(height: 16),
                  Text(
                    'Thanks for ordering with Us',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(String label, String value,
      {bool isSuccess = false, bool isCopyable = false}) {
    Color textColor = isSuccess
        ? Colors.green
        : (value == 'Failed' ? Colors.red : Colors.black87);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
          isCopyable == false
              ? Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                )
              : CopyableText(value)
        ],
      ),
    );
  }
}

class BottomZigZagClipper extends CustomClipper<Path> {
  final double zigzagHeight = 8;
  final double zigzagWidth = 12;

  @override
  Path getClip(Size size) {
    final path = Path();

    // Top edge straight
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - zigzagHeight);

    // Bottom zigzag only
    for (double x = size.width; x > 0; x -= zigzagWidth) {
      path.lineTo(x - zigzagWidth / 2, size.height);
      path.lineTo(x - zigzagWidth, size.height - zigzagHeight);
    }

    // Left back up
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
