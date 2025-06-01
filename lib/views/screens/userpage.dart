

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
  String userId;
  Userpage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    DatabaseService service = DatabaseService();
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<User>(
          future: service.getOwnerByProductId(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // or SkeletonLoader
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData) {
              return Text("User not found.");
            } else {
              final user = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoWidget(
                    username: user.username,
                    email: user.email,
                    bio: "bio",
                  ),
                  Text(
                    "  Listed products: ",
                    style: kTextStyle(size: 17, isBold: true),
                  ),
                  StreamBuilder(
                    stream: service.getProductsByUser(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: SpinKitSpinningLines(
                          color: Colors.black,
                        ));
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                          snapshot.error!.toString(),
                          style: kTextStyle(color: Colors.white),
                        ));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Tasks available'));
                      }
                      List<Product> products = snapshot.data!;
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.push(ProductDetailedScreen(
                                    product: products[index], looped: true));
                              },
                              child: ProductDisplay(
                                img: products[index].imageUrls.first,
                                title: products[index].title,
                                description: products[index].description,
                                price: products[index].price,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                ],
              );
            }
          },
        ));
  }
}
