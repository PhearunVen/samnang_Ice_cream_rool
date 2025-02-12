// ignore_for_file: file_names

class IceCreamItem {
  String id; // Unique identifier for each ice cream roll
  String flavor; // Flavor of the ice cream roll
  double price; // Price of the ice cream roll
  String imageUrl; // URL of the image representing the ice cream roll
  List<String> toppings; // List of toppings
  int quantity; // Number of rolls in an order

  IceCreamItem({
    required this.id,
    required this.flavor,
    required this.price,
    required this.imageUrl,
    this.toppings = const [],
    this.quantity = 1,
  });

  // Factory method to create IceCreamItem from Firestore data
  factory IceCreamItem.fromFirestore(Map<String, dynamic> data, String id) {
    return IceCreamItem(
      id: id,
      flavor: data['flavor'],
      price: data['price'].toDouble(),
      imageUrl: data['imageUrl'], // Directly use the path or URL from Firestore
      toppings: List<String>.from(data['toppings'] ?? []),
      quantity: data['quantity'] ?? 1,
    );
  }
}
