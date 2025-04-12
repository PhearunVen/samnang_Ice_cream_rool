import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/staff/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cart = [];
  double _discount = 0.0;

  List<CartItem> get cart => _cart;

  double get totalPrice {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get discount => _discount;

  double get discountedTotalPrice {
    return totalPrice - _discount;
  }

  void addItem(CartItem item) {
    final existingItemIndex =
        _cart.indexWhere((cartItem) => cartItem.name == item.name);

    if (existingItemIndex != -1) {
      _cart[existingItemIndex].quantity += item.quantity;
    } else {
      _cart.add(item);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  void increaseQuantity(int index) {
    if (index >= 0 && index < _cart.length) {
      _cart[index].quantity += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(int index) {
    if (index >= 0 && index < _cart.length) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity -= 1;
      } else {
        removeItem(index);
      }
      notifyListeners();
    }
  }

  void applyDiscount(double discountPercentage, BuildContext context) {
    if (discountPercentage >= 0 && discountPercentage <= 100) {
      if (discountPercentage == 0) {
        _discount = 0.0; // Reset discount to 0
      } else {
        // Calculate discount based on the total price
        _discount = totalPrice * (discountPercentage / 100);
      }
      notifyListeners();
    } else {}
  }

  void clearDiscount() {
    _discount = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _discount = 0.0;
    notifyListeners();
  }
}
