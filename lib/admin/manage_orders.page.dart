import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  // Sample data for orders based on face recognition
  List<Order> orders = [
    Order(
        id: '001',
        customerName: 'John Doe',
        totalAmount: 15.50,
        status: 'In Preparation'),
    Order(
        id: '002',
        customerName: 'Jane Smith',
        totalAmount: 20.00,
        status: 'Completed'),
    Order(
        id: '003',
        customerName: 'Tom Clark',
        totalAmount: 12.75,
        status: 'In Preparation'),
  ];

  void _updateOrderStatus(Order order, String newStatus) {
    setState(() {
      order.status = newStatus;
    });
  }

  void _deleteOrder(Order order) {
    setState(() {
      orders.remove(order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Apply the gradientCategory here
        ),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                    '${order.customerName} - \$${order.totalAmount.toStringAsFixed(2)}'),
                subtitle: Text('Status: ${order.status}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Complete') {
                      _updateOrderStatus(order, 'Completed');
                    } else if (value == 'Cancel') {
                      _updateOrderStatus(order, 'Canceled');
                    } else if (value == 'Delete') {
                      _deleteOrder(order);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'Complete',
                        child: Text('Mark as Completed'),
                      ),
                      const PopupMenuItem(
                        value: 'Cancel',
                        child: Text('Cancel Order'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete Order'),
                      ),
                    ];
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Order {
  String id;
  String customerName;
  double totalAmount;
  String status;

  Order({
    required this.id,
    required this.customerName,
    required this.totalAmount,
    required this.status,
  });
}
