class Order {
  final String itemName;
  final double itemPrice;
  final String imagePath;
  int quantity;

  Order({
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    this.quantity = 1,
  });

  double get totalPrice => itemPrice * quantity;

  // Convert Order object to Map
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'itemPrice': itemPrice,
      'imagePath': imagePath,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
