import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/pages/home_stuff.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  final List<Map<String, dynamic>> sales = const [
    {
      'id': 'S001', // Sale ID
      'items': [
        {
          'name': 'Vanilla Delight',
          'price': 3.50,
          'amount': 2
        }, // 2 Vanilla Delight
        {'name': 'Mango Tango', 'price': 2.00, 'amount': 1}, // 1 Mango Tango
      ],
      'date': '2024-10-08',
      'time': '10:30 AM',
      'total': 9.00 // Total calculated as (3.50*2 + 2.00*1)
    },
    {
      'id': 'S002', // Sale ID
      'items': [
        {
          'name': 'Chocolate Blast',
          'price': 4.00,
          'amount': 1
        }, // 1 Chocolate Blast
        {
          'name': 'Strawberry Swirl',
          'price': 3.75,
          'amount': 1
        }, // 1 Strawberry Swirl
      ],
      'date': '2024-10-08',
      'time': '11:00 AM',
      'total': 7.75 // Total calculated as (4.00*1 + 3.75*1)
    },
    {
      'id': 'S003', // Sale ID
      'items': [
        {
          'name': 'Blueberry Dream',
          'price': 2.50,
          'amount': 1
        }, // 1 Blueberry Dream
        {'name': 'Minty Fresh', 'price': 3.50, 'amount': 1}, // 1 Minty Fresh
      ],
      'date': '2024-10-07',
      'time': '09:45 AM',
      'total': 6.00 // Total calculated as (2.50*1 + 3.50*1)
    },
    {
      'id': 'S004', // Sale ID
      'items': [
        {'name': 'Banana Bliss', 'price': 3.00, 'amount': 3}, // 3 Banana Bliss
      ],
      'date': '2024-10-07',
      'time': '02:15 PM',
      'total': 9.00 // Total calculated as (3.00*3)
    },
    {
      'id': 'S005', // Sale ID
      'items': [
        {
          'name': 'Coconut Crunch',
          'price': 4.50,
          'amount': 2
        }, // 2 Coconut Crunch
        {'name': 'Berry Blast', 'price': 2.25, 'amount': 1}, // 1 Berry Blast
      ],
      'date': '2024-10-06',
      'time': '08:30 AM',
      'total': 11.25 // Total calculated as (4.50*2 + 2.25*1)
    },
    {
      'id': 'S006', // Sale ID
      'items': [
        {
          'name': 'Pistachio Punch',
          'price': 5.00,
          'amount': 1
        }, // 1 Pistachio Punch
        {'name': 'Cookie Dough', 'price': 2.50, 'amount': 2}, // 2 Cookie Dough
      ],
      'date': '2024-10-06',
      'time': '10:00 AM',
      'total': 10.00 // Total calculated as (5.00*1 + 2.50*2)
    },
    {
      'id': 'S007', // Sale ID
      'items': [
        {
          'name': 'Matcha Madness',
          'price': 2.00,
          'amount': 4
        }, // 4 Matcha Madness
      ],
      'date': '2024-10-05',
      'time': '12:30 PM',
      'total': 8.00 // Total calculated as (2.00*4)
    },
    {
      'id': 'S008', // Sale ID
      'items': [
        {
          'name': 'Hazelnut Heaven',
          'price': 5.50,
          'amount': 2
        }, // 2 Hazelnut Heaven
      ],
      'date': '2024-10-05',
      'time': '03:45 PM',
      'total': 11.00 // Total calculated as (5.50*2)
    },
    {
      'id': 'S009', // Sale ID
      'items': [
        {
          'name': 'Salted Caramel',
          'price': 4.75,
          'amount': 1
        }, // 1 Salted Caramel
        {
          'name': 'Peanut Butter Crunch',
          'price': 2.50,
          'amount': 1
        }, // 1 Peanut Butter Crunch
      ],
      'date': '2024-10-04',
      'time': '09:00 AM',
      'total': 7.25 // Total calculated as (4.75*1 + 2.50*1)
    },
    {
      'id': 'S010', // Sale ID
      'items': [
        {
          'name': 'Mango Passion',
          'price': 3.00,
          'amount': 2
        }, // 2 Mango Passion
        {'name': 'Choco Chunk', 'price': 2.00, 'amount': 1}, // 1 Choco Chunk
      ],
      'date': '2024-10-04',
      'time': '11:30 AM',
      'total': 8.00 // Total calculated as (3.00*2 + 2.00*1)
    },
    {
      'id': 'S011', // Sale ID
      'items': [
        {
          'name': 'Raspberry Ripple',
          'price': 4.00,
          'amount': 1
        }, // 1 Raspberry Ripple
        {'name': 'Brownie Bite', 'price': 3.00, 'amount': 1}, // 1 Brownie Bite
      ],
      'date': '2024-10-03',
      'time': '03:00 PM',
      'total': 7.00 // Total calculated as (4.00*1 + 3.00*1)
    },
    {
      'id': 'S012', // Sale ID
      'items': [
        {'name': 'Vanilla Bean', 'price': 4.50, 'amount': 1}, // 1 Vanilla Bean
      ],
      'date': '2024-10-02',
      'time': '10:15 AM',
      'total': 4.50 // Total calculated as (4.50*1)
    },
    {
      'id': 'S013', // Sale ID
      'items': [
        {
          'name': 'Honeycomb Delight',
          'price': 3.50,
          'amount': 3
        }, // 3 Honeycomb Delight
      ],
      'date': '2024-10-01',
      'time': '01:00 PM',
      'total': 10.50 // Total calculated as (3.50*3)
    },
    {
      'id': 'S014', // Sale ID
      'items': [
        {'name': 'Peach Melba', 'price': 2.75, 'amount': 2}, // 2 Peach Melba
      ],
      'date': '2024-10-01',
      'time': '05:00 PM',
      'total': 5.50 // Total calculated as (2.75*2)
    },
    {
      'id': 'S015', // Sale ID
      'items': [
        {'name': 'Lemon Zest', 'price': 3.00, 'amount': 1}, // 1 Lemon Zest
        {'name': 'Oreo Crunch', 'price': 1.50, 'amount': 3}, // 3 Oreo Crunch
      ],
      'date': '2024-09-30',
      'time': '12:00 PM',
      'total': 8.50 // Total calculated as (3.00*1 + 1.50*3)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Overview'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeStuff(),
              ),
            ); // Replaces OrderPage with HomePage
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt),
                      title: Text('Sale ID: ${sale['id']}'),
                      subtitle: Text(
                        'Date: ${sale['date']} \nTime: ${sale['time']} \nTotal: \$${sale['total']?.toStringAsFixed(2) ?? 'N/A'}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaleDetailPage(sale: sale),
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
      ),
    );
  }
}

class SaleDetailPage extends StatelessWidget {
  final Map<String, dynamic> sale;

  const SaleDetailPage({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sale Details for ID: ${sale['id']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Date: ${sale['date']}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Time: ${sale['time']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Items:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Display each item with image, name, amount, and calculated total
            ...sale['items']?.map<Widget>((item) {
                  final amount = item['amount'] ?? 1;
                  final price = item['price'] ?? 0.0;
                  final imageUrl =
                      item['imageUrl'] ?? 'https://via.placeholder.com/150';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text('$amount x ${item['name']}'),
                    subtitle: Text('Price: \$${price.toStringAsFixed(2)}'),
                    trailing:
                        Text('Total: \$${(price * amount).toStringAsFixed(2)}'),
                  );
                })?.toList() ??
                [],
            const SizedBox(height: 20),
            // Show total price in a decorative box
            Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Total: \$${sale['total']?.toStringAsFixed(2) ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
