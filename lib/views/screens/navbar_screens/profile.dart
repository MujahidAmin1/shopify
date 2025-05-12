import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/authprovider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          CircleAvatar(
            
          ),
          FilledButton(
            onPressed: () {
              context.read<Authprovider>().signOut(context);
            },
            child: Text("Signout"),
          ),
        ],
      ),
    );
  }
}
