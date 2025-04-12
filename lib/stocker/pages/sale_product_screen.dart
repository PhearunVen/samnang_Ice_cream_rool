import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/stocker/model/product_model.dart';
import 'package:samnang_ice_cream_roll/stocker/service/cart_product_provider.dart';

class SellProductScreen extends StatefulWidget {
  final Product product;

  const SellProductScreen({super.key, required this.product});

  @override
  _SellProductScreenState createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  double _quantity = 1.0;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    setState(() {
      _totalPrice = widget.product.price * _quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Sell ${widget.product.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit Type: ${widget.product.unitType}',
                style: TextStyle(fontSize: 16)),
            Text(
                'Price per ${widget.product.unitType}: \$${widget.product.price}',
                style: TextStyle(fontSize: 16)),
            Text(
                'Available Stock: ${widget.product.stock} ${widget.product.unitType}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _quantity > 1
                      ? () {
                          setState(() {
                            _quantity -= 1;
                            _updateTotalPrice();
                          });
                        }
                      : null,
                ),
                Text(
                    '${_quantity.toStringAsFixed(1)} ${widget.product.unitType}',
                    style: TextStyle(fontSize: 20)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _quantity < widget.product.stock
                      ? () {
                          setState(() {
                            _quantity += 1;
                            _updateTotalPrice();
                          });
                        }
                      : null,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Total Price
            Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            SizedBox(height: 30),

            // Add to Cart Button
            ElevatedButton(
              onPressed: () {
                if (_quantity > widget.product.stock) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Not enough stock available!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Add product to cart
                cartProvider.addToCart(widget.product, _quantity);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Added ${_quantity.toStringAsFixed(1)} ${widget.product.unitType} of ${widget.product.name} to cart'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Do not navigate back immediately
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
