// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shopify/utils/ktextStyle.dart';

class UserInfoWidget extends StatelessWidget {
  Image? image;
  String username;
  String bio;
  String? ratings;
  String email;
  UserInfoWidget({
    super.key,
    this.image,
    required this.username,
    required this.email,
    required this.bio,
    this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
            left: 0,
            top: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: kTextStyle(size: 23, isBold: true)),
                  Text(email),
                  Text(bio),
                  Text("Ratings: "),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
