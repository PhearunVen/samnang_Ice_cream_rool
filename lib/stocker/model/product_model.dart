class Product {
  String id;
  String name;
  double price; // Price per unit
  double stock; // Stock in unit type (kg, liter, pieces)
  String unitType; // e.g., kg, liter, piece, dozen
  String category; // Category for filtering (e.g., Meat, Vegetables, Dairy)
  String imageUrl; // URL for the product image

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.unitType,
    required this.category, // Make sure category is required
    required this.imageUrl, // Make sure imageUrl is required
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'unitType': unitType,
      'category': category, // Add category to the map
      'imageUrl': imageUrl, // Add imageUrl to the map
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      stock: map['stock'],
      unitType: map['unitType'],
      category: map['category'], // Ensure category is being parsed
      imageUrl: map['imageUrl'], // Ensure imageUrl is being parsed
    );
  }
}
