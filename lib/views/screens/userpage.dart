import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopify/models/user.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/views/widgets/userinfowidget.dart';

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
                  Text("  Listed products: ",
                      style: kTextStyle(size: 17, isBold: true)),
                      
                ],
              );
            }
          },
        ));
  }
}
