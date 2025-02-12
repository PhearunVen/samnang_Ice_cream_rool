import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;
  String? userEmail; // Store the user's email
  String? storeName; // Store the store name

  @override
  void initState() {
    super.initState();
    fetchUserEmailAndStoreName();
  }

  // Fetch the user's email and store name from Firestore
  Future<void> fetchUserEmailAndStoreName() async {
    try {
      // Retrieve the user's email from local storage
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('email');

      if (storedEmail == null) {
        if (mounted) {
          setState(() {
            errorMessage = 'User email not found. Please log in again.';
            isLoading = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          userEmail = storedEmail; // Store the email in the state
        });
      }

      // Fetch the store name from Firestore using the user's email
      final QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('email', isEqualTo: userEmail)
          .get();

      if (storeSnapshot.docs.isNotEmpty) {
        final storeData =
            storeSnapshot.docs.first.data() as Map<String, dynamic>;
        final fetchedStoreName = storeData['storeName'];

        if (mounted) {
          setState(() {
            storeName = fetchedStoreName; // Fetch store name
          });
        }

        // Fetch orders filtered by the store name
        await fetchOrdersByStoreName();
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Store not found for the user.';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to fetch store name: $e';
          isLoading = false;
        });
      }
    }
  }

  // Fetch orders filtered by store name
  Future<void> fetchOrdersByStoreName() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('storeName', isEqualTo: storeName) // Filter by store name
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> fetchedOrders = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'orderId': doc['orderId'],
                'documentId': doc.id,
              })
          .toList();

      if (mounted) {
        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to fetch orders: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(kToolbarHeight), // Default AppBar height
        child: Container(
          decoration: const BoxDecoration(
            color: MyColors.myappbar, // Use the same gradient as the body
          ),
          child: AppBar(
            backgroundColor:
                Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Remove shadow
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Order List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: MyColors.gradient,
        ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text('Date: $formattedDate'),
                                  Text('Time: $formattedTime'),
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
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final DateTime? timestamp = order['timestamp']?.toDate();
    final String formattedDate =
        timestamp != null ? DateFormat('yyyy-MM-dd').format(timestamp) : 'N/A';
    final String formattedTime =
        timestamp != null ? DateFormat('hh:mm:ss a').format(timestamp) : 'N/A';

    final String orderId = order['orderId'].toString();

    Future<pw.Document> generateOrderPdf(Map<String, dynamic> order) async {
      final pdf = pw.Document();

      final DateTime? timestamp = order['timestamp']?.toDate();
      final String formattedDate = timestamp != null
          ? DateFormat('yyyy-MM-dd').format(timestamp)
          : 'N/A';
      final String formattedTime = timestamp != null
          ? DateFormat('hh:mm:ss a').format(timestamp)
          : 'N/A';

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Order ID: ${order['orderId']}',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Date: $formattedDate',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text('Time: $formattedTime',
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20),
                pw.Text('Items:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                ...order['items']?.map<pw.Widget>((item) {
                      final amount = item['quantity'] ?? 1;
                      final price = item['price']?.toDouble() ?? 0.0;
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('$amount x ${item['itemName']}'),
                          pw.Text('Price: \$${price.toStringAsFixed(2)}'),
                          pw.Text(
                              'Total: \$${(price * amount).toStringAsFixed(2)}'),
                          pw.Divider(),
                        ],
                      );
                    })?.toList() ??
                    [pw.Text('No items found.')],
                pw.SizedBox(height: 20),
                pw.Text(
                    'Total: \$${order['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ],
            );
          },
        ),
      );

      return pdf;
    }

    Future<void> printOrderPdf(Map<String, dynamic> order) async {
      final pdf = await generateOrderPdf(order);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details for ID: $orderId',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.myappbar,
        elevation: 10,
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: MyColors.gradientColors,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      blurRadius: 10, // Shadow blur
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(8), // Margin around the container
                padding:
                    const EdgeInsets.all(16.0), // Padding inside the container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: $formattedDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Time: $formattedTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Store: ${order['storeName'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Items:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...order['items']?.map<Widget>((item) {
                    final amount = item['quantity'] ?? 1;
                    final price = item['price']?.toDouble() ?? 0.0;
                    final imagePath = item['image'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: imagePath != null && imagePath.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(imagePath),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.image),
                              ),
                        title: Text(
                          '$amount x ${item['itemName']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          'Price: \$${price.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Text(
                          'Total: \$${(price * amount).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  })?.toList() ??
                  [const Text('No items found.')],
              const SizedBox(height: 20),
              const Text(
                'Additional Information:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...order.entries.map<Widget>((entry) {
                if (entry.key == 'items' ||
                    entry.key == 'timestamp' ||
                    entry.key == 'documentId') {
                  return const SizedBox.shrink();
                }
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      '${entry.key}: ${entry.value}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Total: \$${order['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await printOrderPdf(order);
        },
        child: const Icon(Icons.print),
      ),
    );
  }
}
