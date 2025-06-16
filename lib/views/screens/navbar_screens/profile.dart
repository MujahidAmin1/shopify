import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/authprovider.dart';
import 'package:shopify/services/database/database.dart';
import 'package:shopify/utils/ktextStyle.dart';
import 'package:shopify/utils/navigate.dart';
import 'package:shopify/views/screens/cart_page.dart';
import 'package:shopify/views/widgets/logout_alert.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService services = DatabaseService();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: services.getOwnerByProductId(_auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("User not found."));
          } else {
            final user = snapshot.data!;
            final email = _auth.currentUser?.email ?? "No email";

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xff8E6CEF),
                          child: const Icon(Icons.person,
                              size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.username,
                          style: kTextStyle(size: 20, isBold: true),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: kTextStyle(
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.bio ?? "No bio available",
                          style: kTextStyle(
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Options
                _buildMenuItem(context, Icons.shopping_bag_outlined, "Orders",
                    () {
                  // Navigate to orders
                }),
                _buildMenuItem(context, Icons.shopping_cart_outlined, "Cart",
                    () {
                  context.push(CartPage());
                }),
                _buildMenuItem(context, Icons.settings_outlined, "Settings",
                    () {
                  // Navigate to settings
                }),
                const Divider(height: 32),
                _buildMenuItem(
                  context,
                  Icons.logout,
                  "Logout",
                  () {
                    showLogoutConfirmationDialog(context, () {
                      context.read<Authprovider>().signOut(context);
                      
                    });
                  },
                  iconColor: Colors.red,
                  textColor: Colors.red,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? iconColor,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: iconColor ?? const Color(0xff8E6CEF)),
      title: Text(
        title,
        style: kTextStyle(
          size: 16,
          color: textColor ?? theme.colorScheme.onSurface,
          isBold: true,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}
