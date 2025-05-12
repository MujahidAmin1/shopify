import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/btm_navbar_provider.dart';
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
        selectedIndex: btmNavBarProvider.selectedIndex,
        onDestinationSelected: btmNavBarProvider.changeIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Iconsax.home_copy),
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.notification_copy),
            icon: Icon(Iconsax.notification),
            label: 'Notifications',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.bookmark_copy),
            icon: Icon(Iconsax.bookmark),
            label: 'Orders',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.profile_2user_copy),
            icon: Icon(Iconsax.profile_2user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
