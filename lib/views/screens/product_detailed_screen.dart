import 'package:flutter/material.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/utils/ktextStyle.dart';

class ProductDetailedScreen extends StatelessWidget {
  final Product product;
  const ProductDetailedScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            product.imageUrls.length <= 1
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product.imageUrls.first,
                      width: double.infinity,
                      height: height * 0.4,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(
                    height: height * 0.4,
                    child: CarouselView(
                      scrollDirection: Axis.horizontal,
                      itemExtent: MediaQuery.of(context).size.width *
                          0.8,
                      children: product.imageUrls
                          .map(
                            (img) => ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                img,
                                width: double.infinity,
                                height: height * 0.4,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: kTextStyle(size: 28, isBold: true)),
                  Text('Category: ${product.category}'),
                  Text(product.description, style: kTextStyle(size: 20)),
                  Text(product.price.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
