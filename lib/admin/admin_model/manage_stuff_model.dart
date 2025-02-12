class Staff {
  String id;
  String name;
  double salary;
  String contact;
  String role;
  DateTime startWork;

  Staff({
    required this.id,
    required this.name,
    required this.salary,
    required this.contact,
    required this.role,
    required this.startWork,
  });

  // Factory method to create an instance from Firestore data
  factory Staff.fromMap(String id, Map<String, dynamic> data) {
    return Staff(
      id: id,
      name: data['name'] ?? 'Unknown', // Provide a meaningful default
      salary: (data['salary'] is num)
          ? (data['salary'] as num).toDouble()
          : 0.00, // Handle numeric conversion
      contact: data['contact'] ?? 'N/A', // Provide a default for missing data
      role: data['role'] ?? 'Unassigned',
      startWork: (data['startWork'] != null)
          ? DateTime.parse(data['startWork'])
          : DateTime.now(), // Handle null and parse date
    );
  }

  // Convert an instance to a Map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'salary': salary,
      'contact': contact, // Ensure proper encryption or hashing before saving
      'role': role,
      'startWork': startWork.toIso8601String(), // Store as ISO string
    };
  }
}
