import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:samnang_ice_cream_roll/staff/pages/order_detail.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;
  String? selectedStoreName; // Selected store name for filtering
  List<String> storeNames = []; // List of all store names
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStoreNames(); // Fetch all store names for the dropdown
    fetchAllOrders(); // Fetch all orders initially
  }

  // Fetch all store names from Firestore
  Future<void> fetchStoreNames() async {
    try {
      final QuerySnapshot storeSnapshot =
          await FirebaseFirestore.instance.collection('stores').get();

      final List<String> fetchedStoreNames =
          storeSnapshot.docs.map((doc) => doc['storeName'] as String).toList();

      setState(() {
        storeNames = fetchedStoreNames;
      });
    } catch (e) {
      //  print('Error fetching store names: $e');
      setState(() {
        errorMessage = 'Failed to fetch store names';
      });
    }
  }

  // Fetch all orders (without filtering)
  Future<void> fetchAllOrders() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> fetchedOrders = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'orderId': doc['orderId'],
                'documentId': doc.id,
              })
          .toList();

      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      //  print('Error fetching orders: $e');
      setState(() {
        errorMessage = 'Failed to fetch orders';
        isLoading = false;
      });
    }
  }

  // Fetch orders filtered by store name
  Future<void> fetchOrdersByStoreName(String storeName) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('storeName', isEqualTo: storeName)
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> fetchedOrders = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'orderId': doc['orderId'],
                'documentId': doc.id,
              })
          .toList();

      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch orders';
        isLoading = false;
      });
    }
  }

  // Clear filter and show all orders
  void clearFilter() {
    setState(() {
      selectedStoreName = null;
      _searchController.clear();
    });
    fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myappbar,
      appBar: AppBar(
        title: const Text('Order List', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColors.myappbar,
        elevation: 10,
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStoreName,
                    decoration: InputDecoration(
                      labelText: 'Filter by Store',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: storeNames
                        .map((store) => DropdownMenuItem(
                              value: store,
                              child: Text(store),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStoreName = value;
                      });
                      fetchOrdersByStoreName(value!);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: clearFilter,
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Filter',
                ),
              ],
            ),
          ),
          // Order List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(
                        child: Text(errorMessage!,
                            style: const TextStyle(color: Colors.red)))
                    : orders.isEmpty
                        ? const Center(
                            child: Text('No orders found.',
                                style: TextStyle(fontSize: 18)))
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final timestamp = order['timestamp']?.toDate();
                              final String formattedDate = timestamp != null
                                  ? DateFormat('yyyy-MM-dd').format(timestamp)
                                  : 'N/A';
                              final String formattedTime = timestamp != null
                                  ? DateFormat('hh:mm:ss a').format(timestamp)
                                  : 'N/A';

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    'Order ID: ${order['orderId']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text('Date: $formattedDate'),
                                      Text('Time: $formattedTime'),
                                      Text(
                                          'Store: ${order['storeName'] ?? 'N/A'}'),
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Total: \$${order['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailPage(order: order),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
