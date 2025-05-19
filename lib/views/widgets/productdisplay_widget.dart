import 'package:flutter/material.dart';
import 'package:shopify/utils/ktextStyle.dart';

class ProductDisplay extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String img;

  const ProductDisplay({
    super.key,
    required this.img,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              img,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kTextStyle(size: 15)),
                Text(description.length > 10
                    ? "${description.substring(0, 6)}..."
                    : description),
                Text("₦${price.toStringAsFixed(2)}",
                    style: kTextStyle(isBold: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
