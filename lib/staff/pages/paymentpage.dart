// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:samnang_ice_cream_roll/staff/model/cart_model.dart'; // Import CartItem
import 'package:samnang_ice_cream_roll/staff/pages/home_stuff.dart'; // Import HomeStaff
import 'package:provider/provider.dart'; // Import Provider
import 'package:samnang_ice_cream_roll/staff/service/cart_service.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import CartProvider

class PaymentPage extends StatefulWidget {
  final double totalPrice; // Discounted total price
  final List<CartItem> cartItems; // List of cart items
  final String userEmail; // Logged-in user's email

  const PaymentPage({
    super.key,
    required this.totalPrice,
    required this.cartItems,
    required this.userEmail,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isQRPayment = false; // to toggle between cash and QR Payment
  String? storeName; // Store name fetched from Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchStoreName(); // Fetch store name when the page loads
  }

  // Fetch store name from Firestore based on the user's email
  Future<void> _fetchStoreName() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('stores')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          storeName = snapshot.docs.first['storeName']; // Fetch store name
        });
      }
    } catch (e) {
      print('Error fetching store name: $e');
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
          decoration: BoxDecoration(color: MyColors.myappbar),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Navigate back to the OrderPage
                Navigator.pop(context);
              },
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Type',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Cash Payment Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    isQRPayment = false;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isQRPayment
                        ? Colors.green.shade100
                        : Colors.green.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isQRPayment
                            ? Icons.radio_button_unchecked
                            : Icons.check_circle,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Cash',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // QR Payment Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    isQRPayment = true;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isQRPayment
                        ? Colors.green.shade300
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isQRPayment
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'QR Payment',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sub Total and Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sub Total',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '\$${widget.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                    '\$${widget.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Store Name
              if (storeName != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Store Name',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      storeName!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              // QR Code (only show if QR Payment is selected)
              if (isQRPayment)
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code,
                        size: 150,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              // Done Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 100),
                  ),
                  onPressed: () async {
                    // Save payment data to Firestore
                    await _savePaymentToFirestore(context);
                  },
                  child: const Text(
                    'DONE',
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
      ),
    );
  }

  Future<void> _savePaymentToFirestore(BuildContext context) async {
    try {
      // Retrieve the user's email from local storage
      final prefs = await SharedPreferences.getInstance();
      final String? userEmail = prefs.getString('email');

      if (userEmail == null) {
        throw Exception('User email not found. Please log in again.');
      }

      // Fetch the store name from Firestore using the user's email
      final QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('email', isEqualTo: userEmail)
          .get();

      if (storeSnapshot.docs.isEmpty) {
        throw Exception('Store not found for the user.');
      }

      final storeData = storeSnapshot.docs.first.data() as Map<String, dynamic>;
      final storeName = storeData['storeName'];

      // Get the current order ID for the specific store and increment it
      final DocumentReference counterRef =
          FirebaseFirestore.instance.collection('counters').doc(storeName);
      final DocumentSnapshot counterSnapshot = await counterRef.get();

      int lastOrderId =
          counterSnapshot.exists ? counterSnapshot['lastOrderId'] ?? 0 : 0;
      int newOrderId = lastOrderId + 1;

      // Update the counter in Firestore for the specific store
      await counterRef
          .set({'lastOrderId': newOrderId}, SetOptions(merge: true));

      // Get a reference to the Firestore collection
      final CollectionReference payments =
          FirebaseFirestore.instance.collection('orders');

      // Prepare the list of items
      List<Map<String, dynamic>> items = widget.cartItems.map((item) {
        return {
          'itemName': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'image': item.imageUrl,
        };
      }).toList();

      // Create a payment record
      await payments.add({
        'orderId':
            newOrderId, // Use the incremented order ID for the specific store
        'totalPrice': widget.totalPrice,
        'paymentType': isQRPayment ? 'QR Payment' : 'Cash',
        'timestamp': DateTime.now(),
        'storeName': storeName, // Store name fetched from Firestore
        'items': items, // List of items with name, price, and quantity
        'userEmail': userEmail, // Include the user's email
      });

      print('Payment saved to Firestore with orderId: $newOrderId');

      // Clear the cart
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clearCart();

      // Navigate to HomeStaff page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeStuff()),
      );
    } catch (e) {
      print('Error saving payment to Firestore: $e');
    }
  }
}
