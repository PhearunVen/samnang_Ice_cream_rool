import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  String id;
  String productId;
  String productName;
  double price;
  int quantity;
  DateTime timestamp;

  Sale({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.timestamp,
  });

  factory Sale.fromMap(Map<String, dynamic> data, String id) {
    return Sale(
      id: id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      price: data['price'] ?? 0.0,
      quantity: data['quantity'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'timestamp': timestamp,
    };
  }
}
