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

      for (var orderDoc in ordersSnapshot.docs) {
        var orderData = orderDoc.data() as Map<String, dynamic>;
        tempRevenue += orderData['totalPrice'] ?? 0.0;

        List<dynamic> items = orderData['items'] ?? [];
        for (var item in items) {
          String itemName = item['itemName'] ?? 'Unknown Item';
          itemsCount[itemName] = (itemsCount[itemName] ?? 0) + 1;
        }
      }

      double avgOrderValue =
          tempTotalOrders > 0 ? tempRevenue / tempTotalOrders : 0.0;

      setState(() {
        totalRevenue = tempRevenue;
        averageOrderValue = avgOrderValue;
        totalOrders = tempTotalOrders;
        mostPopularItems = itemsCount;
      });
    } catch (e) {
      // Handle error silently or log it as needed
    }
  }

  // Fetch the number of documents in the "itemMenu" collection
  Future<void> fetchItemMenuCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('menuItems').get();

      setState(() {
        itemMenuCount = snapshot.docs.length;
      });
    } catch (e) {
      // Handle error silently or log it as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyAdminDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradientColors, // Assumes a predefined gradient
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // **Header**
              Row(
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  ),
                  Text(
                    'Admin Dashboard ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // **Metrics Cards**
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: DashboardCard(
                        title: 'Total Orders',
                        count: totalOrders,
                        icon: Icons.shopping_cart,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 180,
                      child: DashboardCard(
                        title: 'Total Revenue',
                        count: totalRevenue.toInt(),
                        icon: Icons.attach_money,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 180,
                      child: DashboardCard(
                        title: 'Avg Order Value',
                        count: averageOrderValue.toInt(),
                        icon: Icons.paid,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 180,
                      child: DashboardCard(
                        title: 'Menu Items',
                        count: itemMenuCount,
                        icon: Icons.restaurant_menu,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // **Most Popular Items Section**
              Text(
                'Most Popular Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.white70,
              ),
              ...mostPopularItems.entries.map((entry) {
                if (entry.key != 'Unknown Item') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.star, color: Colors.amber),
                        title: Text(
                          entry.key,
                          style: const TextStyle(color: Colors.black),
                        ),
                        trailing: Text(
                          'Sold: ${entry.value}',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 20),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // **Unknown Items Section**
              if (mostPopularItems.containsKey('Unknown Item')) ...[
                const SizedBox(height: 20),
                Text(
                  'Unknown Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.redAccent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.warning, color: Colors.redAccent),
                      title: const Text(
                        'Unknown Item',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Text(
                        'Sold: ${mostPopularItems['Unknown Item']}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
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
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors
                  .blueAccent, // Use a vibrant color or MyColors.primaryColor if defined
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
