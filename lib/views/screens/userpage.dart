import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopify/models/user.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/utils/navigate.dart';
import 'package:shopify/views/widgets/productdisplay_widget.dart';
import 'package:shopify/views/widgets/userinfowidget.dart';

import '../../models/product.dart';
import 'product_detailed_screen.dart';

class Userpage extends StatelessWidget {
  final String userId;
  const Userpage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final service = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Info'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: kTextStyle(size: 20, isBold: true, color: Colors.black),
      ),
      body: FutureBuilder<User>(
        future: service.getOwnerByProductId(userId),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(
              child: Text("Error: ${userSnapshot.error}",
                  style: kTextStyle(color: Colors.red)),
            );
          } else if (!userSnapshot.hasData) {
            return const Center(child: Text("User not found."));
          }

          final user = userSnapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: UserInfoWidget(
                  username: user.username,
                  email: user.email,
                  bio: user.bio ?? 'No bio',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Listed products",
                  style: kTextStyle(size: 18, isBold: true),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: service.getProductsByUser(userId),
                  builder: (context, prodSnapshot) {
                    if (prodSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitSpinningLines(color: Colors.black),
                      );
                    } else if (prodSnapshot.hasError) {
                      return Center(
                        child: Text(
                          prodSnapshot.error!.toString(),
                          style: kTextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final products = prodSnapshot.data;
                    if (products == null || products.isEmpty) {
                      return const Center(child: Text('No products available'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 220,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            context.push(ProductDetailedScreen(
                              product: product,
                              looped: true,
                            ));
                          },
                          child: ProductDisplay(
                            img: product.imageUrls.first,
                            title: product.title,
                            description: product.description,
                            price: product.price,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
