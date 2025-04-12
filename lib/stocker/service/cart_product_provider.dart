import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/stocker/model/product_model.dart';

class CartProductProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Product product, double quantity) {
    final index =
        _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index != -1) {
      _cartItems[index]['quantity'] += quantity;
    } else {
      _cartItems.add({
        'product': product,
        'quantity': quantity,
      });
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item['product'].id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) {
      return sum + (item['product'].price * item['quantity']);
    });
  }

  Future<void> confirmSale() async {
    if (_cartItems.isEmpty) return;

    try {
      final saleRef = await FirebaseFirestore.instance.collection('sales').add({
        'totalPrice': totalPrice,
        'timestamp': Timestamp.now(),
      });

      for (var item in _cartItems) {
        await saleRef.collection('items').add({
          'name': item['product'].name,
          'quantity': item['quantity'],
          'unitType': item['product'].unitType,
          'price': item['product'].price,
          'total': item['product'].price * item['quantity'],
        });
      }

      // Clear the cart only after the sale is successfully saved
      clearCart();
    } catch (e) {
      print('Error saving sale: $e');
      // Optionally, you can show an error message to the user
      rethrow; // Re-throw the error if you want to handle it in the UI
    }
  }
}
