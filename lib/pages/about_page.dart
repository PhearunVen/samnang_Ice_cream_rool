import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('About'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/seller/sell.jpg'), // Seller image
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Phearun - Seller',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Position: Seller',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            Divider(height: 40, thickness: 1, color: Colors.green),
            Text(
              'About the App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Samnang Ice Cream Roll is a convenient app that allows customers to order '
              'delicious ice cream rolls directly from their mobile device. This app is designed to make '
              'the ordering process faster and easier, while helping sellers keep track of orders and manage '
              'inventory efficiently. Enjoy fresh, customizable ice cream at the touch of a button!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Seller Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Phearun is a dedicated seller who strives to deliver the best ice cream rolls in the area. '
              'With a commitment to quality and customer satisfaction, Phearun ensures that each order '
              'is made with care. Stop by for a delightful treat!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
