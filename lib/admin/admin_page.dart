import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/admin/my_admin_drawer.dart';

import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Sample data for the metrics
    double totalRevenue = 15000.00; // Replace with your calculation
    double averageOrderValue = 250.00; // Replace with your calculation
    //int totalOrders = 60; // Replace with your count
    Map<String, int> staffPerformance = {
      'John Doe': 25,
      'Jane Smith': 20,
      'Tom Clark': 15,
    };
    Map<String, int> mostPopularItems = {
      'Espresso': 30,
      'Cappuccino': 25,
      'Latte': 20,
    };

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyAdminDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Use the gradient defined in MyColors
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the body
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu)),
                  const Text(
                    ' Desboard Admin Ice Cream',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DashboardCard(
                        title: 'Total Sales',
                        count: 500,
                        icon: Icons.monetization_on),
                    DashboardCard(
                        title: 'Active Orders',
                        count: 12,
                        icon: Icons.receipt_long),
                    DashboardCard(
                        title: 'Customers', count: 300, icon: Icons.people),
                    DashboardCard(
                        title: 'Menu Items', count: 45, icon: Icons.coffee),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    DashboardCard(
                        title: 'Total Revenue',
                        count: totalRevenue.toInt(),
                        icon: Icons.attach_money),
                    DashboardCard(
                        title: 'Avg Order Value',
                        count: averageOrderValue.toInt(),
                        icon: Icons.paid),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Staff Performance Metrics',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const Divider(
                thickness: 3,
                endIndent: 120,
                color: Colors.black,
              ),
              ...staffPerformance.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('Orders: ${entry.value}'),
                );
              }),
              const SizedBox(height: 20),
              const Text(
                'Most Popular Order',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const Divider(
                thickness: 3,
                endIndent: 120,
                color: Colors.black,
              ),
              ...mostPopularItems.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('Sold: ${entry.value}'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const DashboardCard(
      {super.key,
      required this.title,
      required this.count,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // Increase elevation for a more pronounced shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.black), // Icon color
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Text(count.toString(),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
