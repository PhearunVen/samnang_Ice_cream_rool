import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/pages/order_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isQRPayment = false; // to toggle between cash and QR Payment

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrderPage()));
          },
        ),
      ),
      body: Padding(
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sub Total',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '\$3.00',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$3.00',
                  style: TextStyle(
                    fontSize: 18,
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
                  color: Colors.white,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                ),
                onPressed: () {},
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
    );
  }
}
