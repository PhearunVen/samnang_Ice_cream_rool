import 'package:cloud_firestore/cloud_firestore.dart'; // Added for saleId generation
import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/staff/pages/order_detail.dart';
import 'package:samnang_ice_cream_roll/staff/pages/save_order_page.dart';
import 'package:samnang_ice_cream_roll/util/responsive.dart';
import 'package:samnang_ice_cream_roll/widgets/auth_service.dart';
import 'package:samnang_ice_cream_roll/widgets/logout_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = 0; // Track the selected drawer item index

  // Function to generate a unique sale ID (copied from HomeStuff)
  Future<String> _generateSaleId() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final counterRef = firestore.collection('metadata').doc('counters');

    try {
      final newCounter = await firestore.runTransaction((transaction) async {
        final counterDoc = await transaction.get(counterRef);

        if (!counterDoc.exists) {
          transaction.set(counterRef, {'orderCounter': 1});
          return 1;
        }

        final currentCounter = counterDoc['orderCounter'] ?? 0;
        final incrementedCounter = currentCounter + 1;
        transaction.update(counterRef, {'orderCounter': incrementedCounter});
        return incrementedCounter;
      });

      return newCounter.toString().padLeft(4, '0');
    } catch (e) {
      throw Exception("Failed to generate Sale ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

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
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text("No email found!");
                  } else {
                    return Text(
                      "Email: ${snapshot.data}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    );
                  }
                },
              ),
              accountEmail: const Text(
                'Position: Seller',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/seller/sell.jpg'),
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
                      setState(() => _selectedIndex = 0);
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.money_off_csred_outlined,
                    title: 'Sale',
                    index: 1,
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                      if (Responsive.isMobile(context)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderListPage(),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
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
                    title: 'Shift',
                    index: 5,
                    onTap: () async {
                      setState(() => _selectedIndex = 5);
                      final saleId = await _generateSaleId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaveOrderPage(
                            saleId: saleId,
                            onStop: () {
                              // No state to reset here, just close
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
              indent: 16,
              endIndent: 16,
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
            const SizedBox(height: 16),
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
    required int index,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      leading: Icon(
        icon,
        size: screenWidth < 600 ? 24 : 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth < 600 ? 16 : 18,
        ),
      ),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.blue.withOpacity(0.1),
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
                'assets/images/mongo.png',
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
            width: double.maxFinite,
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
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
