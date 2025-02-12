// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/pages/cart_item_card.dart';
import 'package:samnang_ice_cream_roll/pages/cart_total_session.dart'; // Updated import
import 'package:samnang_ice_cream_roll/pages/empty.cart.dart';
import 'package:samnang_ice_cream_roll/pages/payment_button.dart';
import 'package:samnang_ice_cream_roll/pages/paymentpage.dart';
import 'package:samnang_ice_cream_roll/service/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Adjust import as needed
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    super.key,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    // Retrieve stored email from local storage
    Future<String?> getStoredEmail() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('email'); // Retrieve the stored email
    }

    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(kToolbarHeight), // Default AppBar height
        child: Container(
          decoration: const BoxDecoration(
              color: MyColors.myappbar // Use the same gradient as the body
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
              'Your Order',
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
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final cart = cartProvider.cart;

            return Column(
              children: [
                Expanded(
                  child: cart.isEmpty
                      ? const EmptyCart()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CartItemCard(
                                  item: cart[index],
                                  onIncrease: () =>
                                      cartProvider.increaseQuantity(index),
                                  onDecrease: () =>
                                      cartProvider.decreaseQuantity(index),
                                  onRemove: () =>
                                      cartProvider.removeItem(index),
                                ),
                                const Divider(height: 1, thickness: 1),
                              ],
                            );
                          },
                        ),
                ),
                const CartTotalSection(), // Updated to include discount selection
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: PaymentButton(
                    onPressed: cart.isEmpty
                        ? null // Disable the button if the cart is empty
                        : () async {
                            // Retrieve the stored email
                            String? userEmail = await getStoredEmail();

                            if (userEmail != null) {
                              // Navigate to PaymentPage with the retrieved email
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    totalPrice:
                                        cartProvider.discountedTotalPrice,
                                    cartItems: cartProvider.cart,
                                    userEmail:
                                        userEmail, // Pass the retrieved email
                                  ),
                                ),
                              );
                            } else {
                              // Handle the case where no email is stored (e.g., show an error message)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'No user email found. Please log in again.')),
                              );
                            }
                          },
                    isEnabled:
                        cart.isNotEmpty, // Pass the cart state to the button
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
