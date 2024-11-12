import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/admin/manage_menu_page.dart';
import 'package:samnang_ice_cream_roll/admin/manage_orders.page.dart';
import 'package:samnang_ice_cream_roll/admin/manage_staff_page.dart';
import 'package:samnang_ice_cream_roll/admin/report_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class MyAdminDrawer extends StatefulWidget {
  const MyAdminDrawer({super.key});

  @override
  State<MyAdminDrawer> createState() => _MyAdminDrawerState();
}

class _MyAdminDrawerState extends State<MyAdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Use the gradient defined in MyColors
        ),
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              accountName: Text(
                'Admin: Phearun', // Replace with actual seller's name
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'Position: Amin', // Replace with actual position if needed
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: CircleAvatar(
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
              title: const Text('Ice Cream Menu'),
              onTap: () {
                // Add navigation logic here
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageMenuPage()));
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
              leading: const Icon(Icons.report_off_outlined),
              title: const Text('Report'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportPage()));
              },
            ),
            const Spacer(), // Adds space above the Logout option
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Add logout logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
