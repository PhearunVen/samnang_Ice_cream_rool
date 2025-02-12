import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/pages/order_detail.dart';
import 'package:samnang_ice_cream_roll/util/responsive.dart';
import 'package:samnang_ice_cream_roll/widgets/auth_service.dart';
import 'package:samnang_ice_cream_roll/widgets/logout_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class MyDrawer extends StatefulWidget {
  // final Function(BuildContext) openSettings;
  final Function(int) onMenuItemTapped; // Callback for menu item taps

  const MyDrawer({
    super.key,
    // required this.openSettings,
    required this.onMenuItemTapped,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = 0; // Track the selected drawer item index

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final screenWidth = MediaQuery.of(context).size.width;
    // List of drawer items
    final List<Map<String, dynamic>> _drawerItems = const [
      {'icon': Icons.home, 'title': 'Home'},
      {'icon': Icons.settings, 'title': 'Settings'},
      {'icon': Icons.info, 'title': 'About'},
    ];

    return Drawer(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(gradient: MyColors.gradientColors),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              accountName: FutureBuilder<String?>(
                future: authService.getEmail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loading spinner
                  } else if (snapshot.hasError) {
                    return Text(
                        "Error: ${snapshot.error}"); // Show error message
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text(
                        "No email found!"); // Handle case when email is null
                  } else {
                    return Text(
                      "Email: ${snapshot.data}",
                      style: TextStyle(
                        fontSize:
                            screenWidth < 600 ? 12 : 15, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ); // Display the retrieved email
                  }
                },
              ),
              accountEmail: Text(
                'Position: Seller',
                style: TextStyle(
                  fontSize: screenWidth < 600 ? 15 : 20, // Responsive font size
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/seller/sell.jpg'), // Path to seller's image
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_outlined,
                    title: 'Home',
                    index: 0,
                    onTap: () {
                      // Update the selected index
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.money_off_csred_outlined,
                    title: 'Sale',
                    index: 1,
                    onTap: () {
                      widget.onMenuItemTapped(1); // Navigate to Sale
                      setState(() =>
                          _selectedIndex = 1); // Update the selected index
                      if (Responsive.isMobile(context)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderListPage(),
                          ),
                        );
                      } else {
                        Navigator.pop(
                            context); // Close the drawer on non-mobile devices
                      } // Close the drawer
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.book_outlined,
                    title: 'About',
                    index: 2,
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.message_outlined,
                    title: 'Messages',
                    index: 3,
                    onTap: () {
                      // Add navigation logic here
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.notification_important_outlined,
                    title: 'Notifications',
                    index: 4,
                    onTap: () {
                      _showNotificationDialog(context);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: 'Setting',
                    index: 5,
                    onTap: () {
                      widget.onMenuItemTapped(5); // Navigate to Settings
                      setState(() =>
                          _selectedIndex = 5); // Update the selected index
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black, // Divider color
              thickness: 1, // Thickness of the divider
              indent: 16, // Start padding
              endIndent: 16, // End padding
            ),

            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              index: 6,
              onTap: () {
                LogoutPage().logout(context);
              },
            ),
            const SizedBox(height: 16), // Add some space at the bottom
          ],
        ),
      ),
    );
  }

  // Function to build a drawer item
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index, // Index of the drawer item
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      leading: Icon(
        icon,
        size: screenWidth < 600 ? 24 : 28, // Responsive icon size
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth < 600 ? 16 : 18, // Responsive font size
        ),
      ),
      selected: _selectedIndex == index, // Highlight the selected item
      selectedTileColor:
          Colors.blue.withOpacity(0.1), // Background color for selected item
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          contentPadding: const EdgeInsets.all(16.0),
          title: Row(
            children: [
              Image.asset(
                'assets/images/mongo.png', // Path to the logo image
                width: 70,
                height: 70,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  children: [
                    Text('About Samnang'),
                    Text('Ice Cream Roll'),
                    Text(
                      'v.1.1.0',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: const SizedBox(
            width: double.maxFinite, // Constrain the width
            child: SingleChildScrollView(
              child: ListBody(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Samnang Ice Cream Roll is a convenient app that allows customers to order delicious ice cream rolls directly from their mobile device.',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This app is designed to make the ordering process faster and easier while helping sellers keep track of orders and manage inventory efficiently. Enjoy fresh, customizable ice cream at the touch of a button!',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 116, 32, 241),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: const Row(
            children: [
              Icon(
                Icons.notifications_active,
                size: 50,
              ),
              Text('  Notification'),
            ],
          ),
          content: const Text(
            'Do you want to turn on notifications?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 116, 32, 241),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Add logic to turn on notifications here
                Navigator.of(context)
                    .pop(); // Close the dialog after the action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications turned on!'),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 116, 32, 241),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Turn on',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
