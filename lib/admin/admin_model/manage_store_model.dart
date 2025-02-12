class StoreIceCream {
  String id; // Unique identifier for the store
  String storeName; // Name of the ice cream store
  String email; // Email associated with the store or admin
  String
      password; // Password (hashed or plaintext, depending on your implementation)
  String role; // Role of the user (e.g., admin, staff)

  StoreIceCream({
    required this.id,
    required this.storeName,
    required this.email,
    required this.password,
    required this.role,
  });

  // Factory method to create an instance from Firestore data
  factory StoreIceCream.fromMap(String id, Map<String, dynamic> data) {
    return StoreIceCream(
      id: id,
      storeName: data['storeName'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '', // Ensure this is handled securely
      role: data['role'] ?? '',
    );
  }

  // Convert an instance to a Map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'email': email,
      'password': password, // Ensure proper encryption or hashing before saving
      'role': role,
    };
  }
}
