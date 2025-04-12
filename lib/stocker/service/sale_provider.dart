// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:samnang_ice_cream_roll/stocker/service/cart_product_provider.dart';

// import 'product_provider.dart';

// class SaleProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> recordSale(List<CartProductProvider> cartProduct) async {
//     try {
//       double totalAmount = cartProduct.fold(
//           0, (sum, item) => sum + (item.product.price * item.quantity));

//       // Create a sale record
//       DocumentReference saleRef = await _firestore.collection('sales').add({
//         'timestamp': FieldValue.serverTimestamp(),
//         'totalAmount': totalAmount,
//       });

//       for (var item in cartProduct) {
//         await _firestore.collection('sales/${saleRef.id}/items').add({
//           'productId': item.product.id,
//           'productName': item.product.name,
//           'quantity': item.quantity,
//           'unitType': item.product.unitType,
//           'totalPrice': item.product.price * item.quantity,
//         });

//         // Update stock in Firebase
//         double newStock = item.product.stock - item.quantity;
//         await ProductProvider().updateStock(item.product.id, newStock);
//       }

//       notifyListeners();
//     } catch (e) {
//       print('Error saving sale: $e');
//     }
//   }
// }
