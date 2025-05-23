import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shopify/models/product.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/utils/navigate.dart';
import 'package:shopify/views/screens/userpage.dart';

class ProductDetailedScreen extends StatelessWidget {
  final Product product;
  const ProductDetailedScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                      itemExtent: MediaQuery.of(context).size.width * 0.8,
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: kTextStyle(size: 28, isBold: true)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      "${product.category[0].toUpperCase()}${product.category.substring(1)}",
                      style: kTextStyle(size: 10),
                    ),
                  ),
                  Text(product.description, style: kTextStyle(size: 20)),
                  FutureBuilder(
                    future: databaseService.fetchUsername(product.ownerId),
                    builder: (context, snapshot) {
                      return Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'by '),
                            TextSpan(
                              text: snapshot.data,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final userId = product.ownerId;
                                  await context.push(Userpage(userId: userId));
                                },
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 5),
                  Text(
                    '₦${product.price.toStringAsFixed(2)}',
                    style: kTextStyle(isBold: true, size: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(width: 20),
          IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.shopping_cart),
              style: IconButton.styleFrom(backgroundColor: Colors.green)),
          FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                  backgroundColor: Color(0xff8E6CEF),
                  minimumSize: Size(width * 0.83, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text("Place Order",
                  style: kTextStyle(size: 20, color: Colors.white))),
        ],
      ),
    );
  }
}
