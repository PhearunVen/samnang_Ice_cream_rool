import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/pages/home_stuff.dart';
import 'package:samnang_ice_cream_roll/pages/paymentpage.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int cartItemCount = 1;

  double total = 3;
  double sunTotal = 3;
  double currentSubTotal = 0; // Variable to hold the subtotal
  double currentTotal = 0; // Variable to hold the total

  // Method to increase the cart item count
  void increaseItem() {
    setState(() {
      cartItemCount++;
      subTotal(); // Recalculate subtotal when items are added
      totalItem();
    });
  }

  // Method to decrease the cart item count
  void decreaseItem() {
    setState(() {
      if (cartItemCount > 1) {
        cartItemCount--;
        subTotal(); // Recalculate subtotal when items are removed
        totalItem();
      }
    });
  }

  // Method to calculate the subtotal
  void subTotal() {
    setState(() {
      currentSubTotal = cartItemCount * sunTotal;
    });
  }

  // Method to calculate the total price (can include taxes, discounts, etc.)
  void totalItem() {
    setState(() {
      currentTotal = cartItemCount * total; // You can add more logic here
    });
  }

  @override
  void initState() {
    super.initState();
    subTotal(); // Initialize the subtotal
    totalItem(); // Initialize the total price
  }

  double discountPercentage = 0;
  void _showDiscountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempDiscount =
            discountPercentage; // Temporary variable to hold discount

        return AlertDialog(
          title: const Text('Enter Discount Percentage'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g., 10 for 10%',
            ),
            onChanged: (value) {
              tempDiscount = double.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  discountPercentage = tempDiscount;
                });
                Navigator.of(context).pop(); // Close dialog and save discount
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'assets/images/mongo.png', // Replace with your image path
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mango Ice Roll',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '\$3.00',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Decrease quantity
                                  decreaseItem();
                                },
                                icon: const Icon(Icons.remove, size: 25),
                                color: Colors.red,
                              ),
                              Text(
                                '$cartItemCount', // Display the quantity here
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Increase quantity
                                  increaseItem();
                                },
                                icon: const Icon(Icons.add, size: 25),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 40, color: Colors.grey.shade400),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sub Total',
                  style: TextStyle(fontSize: 16),
                ),
                Text('\$${currentSubTotal.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${currentTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Add More Items'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeStuff()));
              },
            ),
            ListTile(
              title: const Text('Discount'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$discountPercentage%'),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: _showDiscountDialog,
            ),
            ListTile(
              title: const Text('Payment Method'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentPage()));
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                ),
                onPressed: () {},
                child: const Text(
                  'CHECK OUT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
