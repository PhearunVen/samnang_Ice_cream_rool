import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/staff/service/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cart.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.cart[index];
                    return ListTile(
                      leading: Image.network(item.imageUrl),
                      title: Text(item.name),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                      onTap: () {
                        cartProvider.removeItem(index);
                      },
                    );
                  },
                ),
              ),
              Text(
                  'Total Price: \$${cartProvider.totalPrice.toStringAsFixed(2)}'),
              Text(
                  'Discounted Price: \$${cartProvider.discountedTotalPrice.toStringAsFixed(2)}'),
              ElevatedButton(
                onPressed: () {
                  cartProvider.applyDiscount(10, context); // Apply 10% discount
                },
                child: const Text('Apply 10% Discount'),
              ),
              ElevatedButton(
                onPressed: () {
                  cartProvider.clearCart();
                },
                child: const Text('Clear Cart'),
              ),
            ],
          );
        },
      ),
    );
  }
}
