class CartItem {
  final String id; // Unique identifier
  final String name;
  double price; // Current price (can be modified by discount)
  final double originalPrice; // Original price (never modified)
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  })  : originalPrice =
            price, // Initialize originalPrice with the initial price
        assert(price >= 0, 'Price cannot be negative.'),
        assert(quantity >= 1, 'Quantity must be at least 1.');

  // Convert CartItem to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice, // Include originalPrice in the map
      'image': imageUrl,
      'quantity': quantity,
    };
  }

  // Create CartItem from a Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown',
      price: map['price'] ?? 0.0,
      imageUrl: map['image'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  // Calculate total price for the item
  double get totalPrice => price * quantity;

  // Copy method
  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    double? originalPrice,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  // Equality and hashing
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
