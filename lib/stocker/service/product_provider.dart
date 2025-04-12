import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/stocker/model/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch products from Firebase
  Future<void> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      _products.clear(); // Clear the list before adding new products
      _products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners(); // Notify listeners to refresh the UI
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('products').add(product.toMap());

      // Update product ID
      Product newProduct = Product(
        id: docRef.id,
        name: product.name,
        price: product.price,
        stock: product.stock,
        unitType: product.unitType,
        category: product.category,
        imageUrl: product.imageUrl, // Add the imageUrl parameter
      );

      // Update Firestore with the correct ID
      await docRef.update({'id': docRef.id});

      _products.add(newProduct);
      print(
          'Product added with imageUrl: ${newProduct.imageUrl}'); // Debug print statement
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Update stock after a sale
  Future<void> updateStock(String productId, double newStock) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update({'stock': newStock});
    } catch (e) {
      print('Error updating stock: $e');
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      await _firestore
          .collection('products')
          .doc(updatedProduct.id)
          .update(updatedProduct.toMap());

      // Update the local list of products
      int index =
          _products.indexWhere((product) => product.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        print(
            'Product updated with imageUrl: ${updatedProduct.imageUrl}'); // Debug print statement
        notifyListeners();
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Delete a product from Firebase
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
