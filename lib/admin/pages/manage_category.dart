// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagementCategoryScreen extends StatefulWidget {
  const ManagementCategoryScreen({super.key});

  @override
  State<ManagementCategoryScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<ManagementCategoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form key and controller
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  String? _editingCategoryId;

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  // Fetch categories from Firestore
  Stream<List<Category>> getCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  // Add or update a category
  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final categoryName = _categoryNameController.text;

      if (_editingCategoryId == null) {
        // Add new category
        await _firestore.collection('categories').add({
          'name': categoryName,
          'createdAt': DateTime.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category added successfully!')),
        );
      } else {
        // Update existing category
        await _firestore
            .collection('categories')
            .doc(_editingCategoryId)
            .update({
          'name': categoryName,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category updated successfully!')),
        );
      }

      // Clear form
      _clearForm();
    }
  }

  // Delete a category
  Future<void> _deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category deleted successfully!')),
    );
  }

  // Clear form fields
  void _clearForm() {
    _categoryNameController.clear();
    setState(() {
      _editingCategoryId = null;
    });
  }

  // Show dialog for adding/editing
  void _showCategoryForm({String? id, String? name}) {
    if (id != null && name != null) {
      _categoryNameController.text = name;
      _editingCategoryId = id;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              _editingCategoryId == null ? 'Add Category' : 'Edit Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _categoryNameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Category name is required' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveCategory();
                Navigator.of(context).pop();
              },
              child: Text(_editingCategoryId == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<List<Category>>(
          stream: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No categories found.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }
            final categories = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Created: ${category.createdAt.toLocal()}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showCategoryForm(
                              id: category.id, name: category.name),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(category.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(),
        // ignore: sort_child_properties_last
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}

// Category Model
class Category {
  final String id;
  final String name;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  // Convert Firestore document to Category object
  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
