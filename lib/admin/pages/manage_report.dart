// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';

class ManageReport extends StatefulWidget {
  const ManageReport({super.key});

  @override
  State<ManageReport> createState() => ManageReportState();
}

class ManageReportState extends State<ManageReport> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;
  String? selectedStoreName; // Selected store name for filtering
  List<String> storeNames = []; // List of all store names

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchStoreNames(); // Fetch all store names for the dropdown
    fetchAllOrders(); // Fetch all orders initially
  }

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
      setState(() {
        errorMessage = 'Failed to fetch store names';
      });
    }
  }

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

  void clearFilter() {
    setState(() {
      selectedStoreName = null;
    });
    fetchAllOrders();
  }

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
      setState(() {
        errorMessage = 'Failed to fetch orders';
        isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      if (picked.end.isBefore(picked.start)) {
        setState(() {
          errorMessage = 'End date cannot be before start date.';
        });
      } else {
        setState(() {
          startDate = picked.start;
          endDate = picked.end;
          errorMessage = null;
        });
      }
    }
  }

  bool isGeneratingReport = false;
  Future<void> exportReportToCsv() async {
    if (orders.isEmpty) {
      setState(() {
        errorMessage = 'No data to export.';
      });
      return;
    }

    final List<List<dynamic>> csvData = [];
    csvData.add(['Order ID', 'Date', 'Time', 'Store', 'Total Price']);

    for (var order in orders) {
      final timestamp = order['timestamp']?.toDate();
      final formattedDate = timestamp != null
          ? DateFormat('yyyy-MM-dd').format(timestamp)
          : 'N/A';
      final formattedTime = timestamp != null
          ? DateFormat('hh:mm:ss a').format(timestamp)
          : 'N/A';

      csvData.add([
        order['orderId'],
        formattedDate,
        formattedTime,
        order['storeName'] ?? 'N/A',
        order['totalPrice']?.toStringAsFixed(2) ?? 'N/A',
      ]);
    }

    final String csv = const ListToCsvConverter().convert(csvData);

    // Save the CSV file to device storage
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sales_report.csv');
    await file.writeAsString(csv);

    // Share the file using shareXFiles
    try {
      await Share.shareXFiles([XFile(file.path)],
          text: 'Here is the sales report CSV file.');
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to share file.';
      });
    }
  }

  Future<void> generateReport() async {
    if (startDate == null || endDate == null) {
      setState(() {
        errorMessage = 'Please select a date range.';
      });
      return;
    }

    setState(() {
      isGeneratingReport = true;
    });

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .where('timestamp', isLessThanOrEqualTo: endDate)
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> fetchedOrders = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'orderId': doc['orderId'],
                'documentId': doc.id,
              })
          .toList();

      // Calculate total sales and items sold
      double totalSales = 0;
      int totalItems = 0;

      for (var order in fetchedOrders) {
        if (order['totalPrice'] != null && order['totalPrice'] is num) {
          totalSales += (order['totalPrice'] as num).toDouble();
        }
        if (order['items'] != null && order['items'] is List) {
          totalItems += (order['items'] as List).length;
        }
      }

      // Display the report
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
        errorMessage = null;
      });

      // Show a dialog with the report summary
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sales Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Sales: \$${totalSales.toStringAsFixed(2)}'),
              Text('Total Items Sold: $totalItems'),
              Text(
                  'Date Range: ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to generate report';
      });
    } finally {
      setState(() {
        isGeneratingReport = false;
      });
    }
  }

  Widget buildSalesChart() {
    final Map<String, double> dailySales = {};

    for (var order in orders) {
      final timestamp = order['timestamp']?.toDate();
      if (timestamp != null) {
        final date = DateFormat('yyyy-MM-dd').format(timestamp);
        dailySales[date] = (dailySales[date] ?? 0) + (order['totalPrice'] ?? 0);
      }
    }

    final List<FlSpot> spots = [];
    int index = 0;
    dailySales.forEach((date, total) {
      spots.add(FlSpot(index.toDouble(), total));
      index++;
    });

    return Container(
      height: 300, // Fixed height for the chart
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
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
                const SizedBox(height: 16),
                // Date Range Picker
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDateRange(context),
                        child: Text(
                          startDate == null || endDate == null
                              ? 'Select Date Range'
                              : 'Date Range: ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          startDate = null;
                          endDate = null;
                        });
                      },
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear Date Range',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isGeneratingReport ? null : generateReport,
                  child: isGeneratingReport
                      ? const CircularProgressIndicator()
                      : const Text('Generate Report'),
                ),
                ElevatedButton(
                  onPressed: exportReportToCsv,
                  child: const Text('Export to CSV'),
                ),
              ],
            ),
          ),
          // Chart Section
          Expanded(
            child: orders.isEmpty
                ? const Center(
                    child: Text(
                      'No data available for the selected date range.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : buildSalesChart(),
          ),
        ],
      ),
    );
  }
}
