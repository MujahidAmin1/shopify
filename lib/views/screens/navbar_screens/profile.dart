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
            return CustomScrollView(
              slivers: [
                // Header Section
                SliverAppBar(
                  expandedHeight: 280, // Increased to accommodate title
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff8E6CEF), Color(0xff6A1B9A)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Profile",
                              style: kTextStyle(
                                size: 24,
                                color: Colors.white,
                                isBold: true,
                              ),
                            ),
                            const SizedBox(height: 12),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 50, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user.username,
                              style: kTextStyle(size: 28, color: Colors.white, isBold: true),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.bio ?? "No bio",
                              style: kTextStyle(size: 16, color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  Icon(
                                    i < 4 ? Icons.star : Icons.star_border,
                                    color: Colors.yellow,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Menu Options Section
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildMenuCard(context, Icons.shopping_bag_outlined, 'Orders', () {
                        // Navigate to Orders
                      }, theme),
                      _buildMenuCard(context, Icons.shopping_cart_outlined, 'Cart', () {
                        context.push(CartPage());
                      }, theme),
                      _buildMenuCard(context, Icons.settings_outlined, 'Settings', () {
                        // Navigate to Settings
                      }, theme),
                      const SizedBox(height: 20),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 10),
                      _buildMenuCard(context, Icons.logout, 'Logout', () {
                        showLogoutConfirmationDialog(context, () {
                          context.read<Authprovider>().signOut(context);
                        });
                      }, theme, color: Colors.red),
                    ]),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
    ThemeData theme, {
    Color? color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: color ?? Color(0xff8E6CEF),
          size: 28,
        ),
        title: Text(
          title,
          style: kTextStyle(size: 16, color: theme.colorScheme.onSurface, isBold: true),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}