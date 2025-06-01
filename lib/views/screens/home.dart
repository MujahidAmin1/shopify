import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/btm_navbar_provider.dart';
import 'package:shopify/utils/navigate.dart';
import 'package:shopify/views/screens/create_product.dart';
import 'package:shopify/views/screens/navbar_screens/firstscreen.dart';
import 'package:shopify/views/screens/navbar_screens/notification.dart';
import 'package:shopify/views/screens/navbar_screens/order_screen.dart';
import 'package:shopify/views/screens/navbar_screens/profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Widget> screens = [
  Firstscreen(),
  NotificationScreen(),
  OrderScreen(),
  ProfileScreen(),
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var btmNavBarProvider = Provider.of<BtmNavbarProvider>(context);
    return Scaffold(
      body: IndexedStack(
        index: btmNavBarProvider.selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Color(0xff8E6CEF),
        selectedIndex: btmNavBarProvider.selectedIndex,
        onDestinationSelected: btmNavBarProvider.changeIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Iconsax.home),
            icon: Icon(Iconsax.home_copy),
            label: 'Home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.notification),
            icon: Icon(Iconsax.notification_copy),
            label: 'Notifications',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.bookmark),
            icon: Icon(Iconsax.bookmark_copy),
            label: 'Orders',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.profile_2user),
            icon: Icon(Iconsax.profile_2user_copy),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff8E6CEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => context.push(CreateProduct()),
        child: Icon(Iconsax.additem),
      ),
    );
  }
}
