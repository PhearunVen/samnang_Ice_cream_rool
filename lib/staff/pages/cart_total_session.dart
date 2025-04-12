import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/staff/service/cart_service.dart'; // Adjust import as needed

class CartTotalSection extends StatelessWidget {
  const CartTotalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalPrice = cartProvider.totalPrice;
    final discount = cartProvider.discount;
    final discountedTotalPrice = cartProvider.discountedTotalPrice;

    // List of predefined discount percentages
    final List<double> discountOptions = [0, 10, 20, 30, 50, 100];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Discount',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                "-\$${discount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                "\$${discountedTotalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Discount Selection
          Row(
            children: [
              Expanded(
                flex: 3, // Adjust flex factor as needed
                child: DropdownButton<double>(
                  value: null, // No default selection
                  hint: const Text('Choose Discount'),
                  isExpanded: true, // Ensure the dropdown takes available space
                  items: discountOptions.map((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text('$value%'),
                    );
                  }).toList(),
                  onChanged: (double? value) {
                    if (value != null) {
                      cartProvider.applyDiscount(value, context);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2, // Adjust flex factor as needed
                child: ElevatedButton(
                  onPressed: () {
                    // print("Clear Discount button pressed"); // Debugging
                    cartProvider.clearDiscount();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Clear Discount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
