// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final DateTime? createdAt;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    this.createdAt,
  });

  // Copy with method
  MenuItem copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? category,
    DateTime? createdAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert MenuItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'category': category,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  // Convert JSON to MenuItem
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: json['category'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Factory constructor to create an instance from Firestore data
  factory MenuItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      id: doc.id,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      image: data['image'] as String,
      category: data['category'] as String,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Method to convert from a Map<String, dynamic> to a MenuItem object
  static MenuItem fromMap(Map<String, dynamic> data) {
    return MenuItem(
      id: data['id'] as String,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      image: data['image'] as String,
      category: data['category'] as String,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Method to convert MenuItem to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'category': category,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
