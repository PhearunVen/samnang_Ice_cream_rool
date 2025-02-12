import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samnang_ice_cream_roll/admin/pages/my_admin_drawer.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // State variables for storing data
  double totalRevenue = 0.0;
  double averageOrderValue = 0.0;
  int totalOrders = 0;
  int itemMenuCount = 0;
  Map<String, int> mostPopularItems = {};

  @override
  void initState() {
    super.initState();
    fetchOrdersData();
    fetchItemMenuCount();
  }

  // Fetch Orders Data from Firebase Firestore
  Future<void> fetchOrdersData() async {
    try {
      QuerySnapshot ordersSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      double tempRevenue = 0.0;
      int tempTotalOrders = ordersSnapshot.docs.length;
      Map<String, int> itemsCount = {};
      // ignore: unused_local_variable
      int unknownItemCount = 0; // Track unknown items

      for (var orderDoc in ordersSnapshot.docs) {
        var orderData = orderDoc.data() as Map<String, dynamic>;

        tempRevenue += orderData['totalPrice'] ?? 0.0;

        List<dynamic> items = orderData['items'] ?? [];
        for (var item in items) {
          String itemName = item['itemName'] ?? 'Unknown Item';
          if (itemName == 'Unknown Item') {
            unknownItemCount++; // Increment unknown item count
            //  print('Found an unknown item in order: ${orderDoc.id}');
          } else {
            itemsCount[itemName] = (itemsCount[itemName] ?? 0) + 1;
          }
        }
      }

      double avgOrderValue =
          tempTotalOrders > 0 ? tempRevenue / tempTotalOrders : 0.0;

      setState(() {
        totalRevenue = tempRevenue;
        averageOrderValue = avgOrderValue;
        totalOrders = tempTotalOrders;
        mostPopularItems = itemsCount;
        // Optionally, store unknownItemCount in state if needed
      });

      // Log the total number of unknown items
      //  print('Total unknown items: $unknownItemCount');
    } catch (e) {
      //  print("Error fetching orders: $e");
    }
  }

  // Fetch the number of documents in the "itemMenu" collection
  Future<void> fetchItemMenuCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('menuItems').get();

      setState(() {
        itemMenuCount = snapshot.docs.length; // Count the documents
      });
    } catch (e) {
      //  print("Error fetching itemMenu count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyAdminDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradientColors,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu),
                  ),
                  const Text(
                    'Dashboard Admin Ice Cream',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Cards for metrics
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DashboardCard(
                        title: 'Total Orders',
                        count: totalOrders,
                        icon: Icons.shopping_cart),
                    DashboardCard(
                        title: 'Total Revenue',
                        count: totalRevenue.toInt(),
                        icon: Icons.attach_money),
                    DashboardCard(
                        title: 'Avg Order Value',
                        count: averageOrderValue.toInt(),
                        icon: Icons.paid),
                    DashboardCard(
                      title: 'Menu Items',
                      count: itemMenuCount, // Show item count here
                      icon: Icons.restaurant_menu,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Most Popular Items Section
              // Most Popular Items Section
              const Text(
                'Most Popular Orders',
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
// Unknown Items Section
              if (mostPopularItems.containsKey('Unknown Item'))
                const Text(
                  'Unknown Items',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              if (mostPopularItems.containsKey('Unknown Item'))
                ListTile(
                  title: const Text('Unknown Item'),
                  trailing: Text('Sold: ${mostPopularItems['Unknown Item']}'),
                ),
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

  const DashboardCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.black),
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
