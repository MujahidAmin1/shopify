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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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
            return Column(
              children: [
                // HEADER SECTION
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white, // Optional
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.username,
                                style: kTextStyle(
                                    size: 20,
                                    isBold: true,
                                    color: Colors.white)),
                            const SizedBox(height: 5),
                            Text(user.bio ?? "No bio",
                                style: kTextStyle(
                                    size: 14, color: Colors.white70)),
                            const SizedBox(height: 5),
                            Text("Ratings: ★★★★☆",
                                style: kTextStyle(
                                    size: 14, color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // MENU OPTIONS
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildTile(context, Icons.shopping_bag_outlined, 'Orders',
                          onTap: () {
                        // Navigate to Orders
                      }),
                      _buildTile(context, Icons.shopping_cart_outlined, 'Cart',
                          onTap: () {
                        context.push(CartPage());
                      }),
                      _buildTile(context, Icons.settings_outlined, 'Settings',
                          onTap: () {
                        // Navigate to Settings
                      }),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      _buildTile(context, Icons.logout, 'Logout', onTap: () {
                        showLogoutConfirmationDialog(
                          context,
                          () {
                            context.read<Authprovider>().signOut(context);
                          },
                        );
                      }, color: Colors.red),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    IconData icon,
    String title, {
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Ink(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800
              : theme.colorScheme.surfaceVariant.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color ?? theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: kTextStyle(
                      size: 16,
                      color: color ?? theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
