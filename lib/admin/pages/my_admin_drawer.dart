import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/admin/pages/manage_category.dart';

import 'package:samnang_ice_cream_roll/admin/pages/manage_orders.page.dart';
import 'package:samnang_ice_cream_roll/admin/pages/manage_report.dart';
import 'package:samnang_ice_cream_roll/admin/pages/manage_staff_page.dart';
import 'package:samnang_ice_cream_roll/admin/pages/manage_store.dart';
import 'package:samnang_ice_cream_roll/admin/pages/menu_management_screen.dart';
import 'package:samnang_ice_cream_roll/admin/pages/report_page.dart';
import 'package:samnang_ice_cream_roll/widgets/auth_service.dart';
import 'package:samnang_ice_cream_roll/widgets/logout_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class MyAdminDrawer extends StatefulWidget {
  const MyAdminDrawer({super.key});

  @override
  State<MyAdminDrawer> createState() => _MyAdminDrawerState();
}

class _MyAdminDrawerState extends State<MyAdminDrawer> {
// Function to log out the user
  final _logout = LogoutPage();
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient:
              MyColors.gradientColors, // Use the gradient defined in MyColors
        ),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              accountName: FutureBuilder(
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
                      "email: ${snapshot.data}",
                      style: const TextStyle(fontSize: 18),
                    ); // Display the retrieved email
                  }
                },
              ),
              accountEmail: const Text(
                'Position: Amin', // Replace with actual position if needed
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/seller/sell.jpg'), // Path to seller's image
              ),
            ),
            const Divider(
              // Add a divider below the header
              color: Colors.black, // Divider color
              thickness: 1, // Thickness of the divider
              indent: 16, // Start padding
              endIndent: 16, // End padding
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Dashboard'),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee_outlined),
              title: const Text('Manage Category'),
              onTap: () {
                // Add navigation logic here
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ManagementCategoryScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee_outlined),
              title: const Text('Manage Menu'),
              onTap: () {
                // Add navigation logic here
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuManagementScreen()));
              },
            ),
            ListTile(
                leading: const Icon(Icons.book_outlined),
                title: const Text('Manage Order'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageOrdersPage()));
                }),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Manage Stuff'),
              onTap: () {
                // Add navigation logic here
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageStaffPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.store_mall_directory_outlined),
              title: const Text('Manage Store'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageStore()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_off_outlined),
              title: const Text('Report'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_off_outlined),
              title: const Text('Manage Report'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageReport()));
              },
            ),
            const Spacer(), // Adds space above the Logout option
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
