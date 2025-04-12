import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/staff/service/cart_service.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class SaveOrderPage extends StatelessWidget {
  final String saleId;
  final VoidCallback onStop;

  const SaveOrderPage({super.key, required this.saleId, required this.onStop});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Save Order - Sale ID: $saleId'),
        backgroundColor: MyColors.myappbar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Order in Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cartProvider.cart.isEmpty
                  ? const Center(child: Text('No items in cart yet.'))
                  : ListView.builder(
                      itemCount: cartProvider.cart.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartProvider.cart[index];
                        return ListTile(
                          leading: cartItem.imageUrl.isNotEmpty
                              ? Image.network(
                                  cartItem.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image, size: 50),
                          title: Text(cartItem.name),
                          subtitle:
                              Text('\$${cartItem.price.toStringAsFixed(2)}'),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onStop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Stop Order',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
