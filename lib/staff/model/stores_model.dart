class Store {
  final String id; // Add id field
  final String storeName;
  final String email;
  final String password;
  final String role;

  Store({
    required this.id, // id should be required in the constructor
    required this.storeName,
    required this.email,
    required this.password,
    required this.role,
  });

  // Factory method to create a Store from a Firestore document
  factory Store.fromMap(Map<String, dynamic> map, String id) {
    return Store(
      id: id, // Pass the document id
      storeName: map['storeName'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }

  // Convert the Store to a Map for Firestore save
  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
