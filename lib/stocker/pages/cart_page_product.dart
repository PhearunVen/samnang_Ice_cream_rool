import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/stocker/service/cart_product_provider.dart';

import 'package:samnang_ice_cream_roll/stocker/service/product_provider.dart';

class CartPageProduct extends StatelessWidget {
  const CartPageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProductProvider>(context);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.cartItems.isEmpty
                ? Center(
                    child: Text(
                      'Your cart is empty.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      final product = item['product'];
                      final quantity = item['quantity'];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                            'Quantity: ${quantity.toStringAsFixed(1)} ${product.unitType} | Total: \$${(product.price * quantity).toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            cartProvider.removeFromCart(product);
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (cartProvider.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: cartProvider.cartItems.isEmpty
                  ? null // Disable the button if the cart is empty
                  : () async {
                      // Update stock quantities
                      for (var item in cartProvider.cartItems) {
                        final product = item['product'];
                        final quantity = item['quantity'];
                        final newStock = product.stock - quantity;

                        if (newStock >= 0) {
                          await productProvider.updateStock(
                              product.id, newStock);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Insufficient stock for ${product.name}. Sale cannot be confirmed.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return; // Stop the process if stock is insufficient
                        }
                      }

                      // Confirm the sale
                      await cartProvider.confirmSale();

                      // Refresh the product list to update the UI
                      await productProvider.fetchProducts();

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sale confirmed!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    },
              child: Text('Confirm Sale'),
            ),
          ),
        ],
      ),
    );
  }
}
