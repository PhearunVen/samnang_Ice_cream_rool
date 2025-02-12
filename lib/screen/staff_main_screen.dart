import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/pages/home_stuff.dart';
import 'package:samnang_ice_cream_roll/pages/my_drawer.dart';
import 'package:samnang_ice_cream_roll/pages/order_detail.dart';
import 'package:samnang_ice_cream_roll/pages/order_page.dart';
import 'package:samnang_ice_cream_roll/pages/setting_page.dart';
import 'package:samnang_ice_cream_roll/util/responsive.dart';
import 'package:samnang_ice_cream_roll/widgets/main_screen.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({super.key});

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  int currentIndex = 0; // Track the current selected index
  int _crossAxisCount = 2; // For grid layout in SettingsPage

  // List of screens to display based on the selected index
  final List<Widget> screens = [
    const HomeStuff(),
    const OrderListPage(),
    const OrderPage(), // Added OrderPage to the screens list
    SettingsPage(
      initialCrossAxisCount: 2,
      onCrossAxisCountChanged: (int count) {},
    ),
  ];

  // Open the SettingsPage and update the crossAxisCount
  void _openSettings(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          initialCrossAxisCount: _crossAxisCount,
          onCrossAxisCountChanged: (int count) {
            setState(() {
              _crossAxisCount = count;
            });
          },
        ),
      ),
    );
  }

  // Handle menu item taps
  void _onMenuItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      sideMenu: MyDrawer(
        onMenuItemTapped: _onMenuItemTapped,
        //openSettings: _openSettings, // Pass the openSettings method
      ),
      desboard: Responsive.isDesktop(context) || Responsive.isTablet(context)
          ? screens[currentIndex] // Show content based on index for mobile
          : const HomeStuff(), // Default screen for non-mobile
      someOrder: const OrderPage(), // Hardcoded OrderPage
    );
  }
}
