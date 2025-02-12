import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For File handling
import 'package:samnang_ice_cream_roll/admin/admin_model/manage_menu.dart';
import 'package:image/image.dart' as img;

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker(); // For image picking

  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _imageUrl;
  MenuItem? _editingItem;
  File? _imageFile; // To store the selected image file

  // Category dropdown
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Fetch categories from Firestore
  Future<void> _fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    setState(() {
      _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories[0]; // Set default selected category
      }
    });
  }

  // Fetch menu items from Firestore
  Stream<List<MenuItem>> getMenuItems() {
    return _firestore.collection('menuItems').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    });
  }

  // Add or update a menu item
  Future<void> _saveMenuItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator
        EasyLoading.show(status: 'Saving...');

        // Upload image if a new file is selected
        if (_imageFile != null) {
          final fileName = DateTime.now().toString();
          final storageRef = _storage.ref().child('menu_images/$fileName');
          await storageRef.putFile(_imageFile!);
          _imageUrl = await storageRef.getDownloadURL();
        }

        final name = _nameController.text;
        final price = double.parse(_priceController.text);

        final menuItem = MenuItem(
          id: _editingItem?.id ?? DateTime.now().toString(),
          name: name,
          price: price,
          image: _imageUrl ?? _editingItem?.image ?? '',
          category: _selectedCategory ?? '', // Use selected category
          createdAt: _editingItem?.createdAt ?? DateTime.now(),
        );

        if (_editingItem == null) {
          // Add new item
          await _firestore
              .collection('menuItems')
              .doc(menuItem.id)
              .set(menuItem.toFirestore());
        } else {
          // Update existing item
          await _firestore
              .collection('menuItems')
              .doc(menuItem.id)
              .update(menuItem.toFirestore());
        }

        // Show success message
        EasyLoading.showSuccess('Saved successfully!');
      } catch (e) {
        // Show error message
        EasyLoading.showError('Failed to save: $e');
      } finally {
        // Clear form
        _clearForm();
      }
    }
  }

  // Delete a menu item
  Future<void> _deleteMenuItem(String id) async {
    await _firestore.collection('menuItems').doc(id).delete();
  }

  // Clear form fields
  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    setState(() {
      _imageUrl = null;
      _editingItem = null;
      _imageFile = null;
      _selectedCategory = _categories.isNotEmpty ? _categories[0] : null;
    });
  }

  Future<File?> _compressImage(File file) async {
    final image = img.decodeImage(file.readAsBytesSync());
    if (image == null) return null;

    // Resize the image to a maximum width of 800 pixels
    final resizedImage = img.copyResize(image, width: 800);

    // Save the compressed image to a temporary file
    final compressedFile = File('${file.path}_compressed.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

    return compressedFile;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressedFile = await _compressImage(File(pickedFile.path));
      setState(() {
        _imageFile = compressedFile;
      });
    }
  }

  // Show dialog for adding/editing
  void _showMenuItemForm(MenuItem? item) {
    if (item != null) {
      _nameController.text = item.name;
      _priceController.text = item.price.toString();
      _selectedCategory = item.category;
      _imageUrl = item.image;
      _editingItem = item;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  _editingItem == null ? 'Add Menu Item' : 'Edit Menu Item'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Name is required' : null,
                      ),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Price is required' : null,
                      ),
                      const SizedBox(height: 16),
                      // Category dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Category is required' : null,
                      ),
                      const SizedBox(height: 16),
                      // Display selected image or placeholder
                      _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : _imageUrl != null
                              ? Image.network(
                                  _imageUrl!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image, size: 100),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await _pickImage();
                          setState(() {}); // Rebuild the dialog
                        },
                        child: const Text('Pick Image'),
                      ),
                    ],
                  ),
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
                    await _saveMenuItem();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: Text(_editingItem == null ? 'Add' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        actions: [
          IconButton(
            onPressed: () => _showMenuItemForm(null),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: getMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu items found.'));
          }
          final menuItems = snapshot.data!;
          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                    '\$${item.price.toStringAsFixed(2)} - ${item.category}'),
                leading: item.image.isNotEmpty
                    ? Image.network(
                        item.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showMenuItemForm(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteMenuItem(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
