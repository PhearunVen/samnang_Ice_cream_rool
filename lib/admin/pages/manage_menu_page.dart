// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class ManageMenuPage extends StatefulWidget {
  const ManageMenuPage({super.key});

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  List<File> _imageFiles = [];
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _addImage() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        // Step 1: Ask the user to enter item details (name and price) first
        String name = '';
        double price = 0.0;

        File? selectedImage;

        bool shouldSave = false; // To check if the user pressed "Save"

        await showDialog(
          context: context,
          builder: (context) {
            final nameController = TextEditingController();
            final priceController = TextEditingController();

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text("Enter Item Details"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Name"),
                      ),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: "Price"),
                        keyboardType: TextInputType.number,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value!),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (pickedFile != null) {
                            // Save the selected image locally
                            final appDir =
                                await getApplicationDocumentsDirectory();
                            final imageName = path.basename(pickedFile.path);
                            final savedImage =
                                File("${appDir.path}/$imageName");

                            await File(pickedFile.path).copy(savedImage.path);

                            setState(() {
                              selectedImage = savedImage;
                            });
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Choose Image'),
                      ),
                      const SizedBox(height: 10),
                      selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              width: 100,
                              height: 100,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  actions: [
                    // Save button
                    TextButton(
                      onPressed: () {
                        name = nameController.text;
                        price = double.tryParse(priceController.text) ?? 0.0;
                        if (name.isNotEmpty &&
                            price > 0 &&
                            selectedImage != null) {
                          shouldSave = true;
                          Navigator.of(context).pop(); // Close the dialog
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please enter valid name, price, and image."),
                            ),
                          );
                        }
                      },
                      child: const Text("Save"),
                    ),
                    // Cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Close the dialog without saving
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                );
              },
            );
          },
        );

        // If user clicked "Save", continue saving the data
        if (shouldSave) {
          // Step 2: Save the data to Firestore
          await _saveToFirestore(
              name, price, _selectedCategory, selectedImage!.path);

          // Step 3: Update the UI with the new image
          setState(() {
            _imageFiles.add(selectedImage!);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $e"),
        ));
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Storage permission denied."),
      ));
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _saveToFirestore(String name, double price,
      String selecteCatagory, String imagePath) async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('menuItems').add({
        'name': name,
        'price': price,
        'category': _selectedCategory,
        'imagePath': imagePath,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item saved to Firebase")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving to Firebase: $e")),
      );
    }
  }

  Future<void> _updateImage(
      {required QueryDocumentSnapshot data,
      required String documentId,
      required String currentImagePath}) async {
    String updatedName = data['name']; // Pre-fill name from Firestore
    double updatedPrice = data['price']; // Pre-fill price from Firestore
    String selectedCategory =
        data['category']; // Pre-fill category from Firestore
    File? selectedImage;

    final status = await Permission.storage.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Storage permission denied."),
      ));
      return;
    }

    // Show the dialog to update the data
    await showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: updatedName);
        final priceController =
            TextEditingController(text: updatedPrice.toString());

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Item Details"),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pre-filled Name input field
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    // Pre-filled Price input field
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                    ),
                    // Dropdown for category, pre-selected
                    DropdownButtonFormField<String>(
                      value: _categories.contains(_selectedCategory)
                          ? _selectedCategory
                          : null,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // Display the current image or selected new one
                    selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            width: 100,
                            height: 100,
                          )
                        : currentImagePath.isNotEmpty
                            ? Image.file(
                                File(currentImagePath),
                                width: 100,
                                height: 100,
                              )
                            : const Text("No image selected."),
                    const SizedBox(height: 10),
                    // Button to select a new image
                    ElevatedButton.icon(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          final appDir =
                              await getApplicationDocumentsDirectory();
                          final imageName = path.basename(pickedFile.path);
                          final savedImage = File("${appDir.path}/$imageName");

                          await File(pickedFile.path).copy(savedImage.path);

                          setState(() {
                            selectedImage = savedImage;
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Choose New Image'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              actions: [
                // Save button
                TextButton(
                  onPressed: () async {
                    updatedName = nameController.text;
                    updatedPrice =
                        double.tryParse(priceController.text) ?? updatedPrice;

                    try {
                      final firestore = FirebaseFirestore.instance;

                      // Update the Firestore document
                      await firestore
                          .collection('menuItems')
                          .doc(documentId)
                          .update({
                        'name': updatedName,
                        'price': updatedPrice,
                        'category': selectedCategory,
                        'imagePath': selectedImage?.path ?? currentImagePath,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Item updated successfully")),
                      );
                      Navigator.of(context).pop(); // Close the dialog
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error updating item: $e")),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
                // Cancel button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteItem(String docId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('menuItems').doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting item: $e")),
      );
    }
  }

  Widget _buildItemList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menuItems').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(color: Colors.grey),
          child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown';
              final price = data['price'] ?? 0.0;
              final category = data['category'] ?? 'Uncategorized';
              final imagePath = data['imagePath'] ?? '';

              return ListTile(
                leading: imagePath.isNotEmpty
                    ? Image.file(
                        File(imagePath),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image, size: 50),
                title: Text(name),
                subtitle: Row(
                  children: [
                    Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.pink),
                    ),
                    Text('$category')
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        final docId = doc.id; // Firestore document ID
                        _updateImage(
                          data: doc, // Pass the entire document data
                          documentId: docId,
                          currentImagePath: imagePath,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(doc.id), // Delete the item
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _loadCategories() async {
    final categories = await _fetchCategories();
    setState(() {
      _categories = categories;
      // Ensure _selectedCategory is valid
      if (!_categories.contains(_selectedCategory)) {
        _selectedCategory = _categories.isNotEmpty ? _categories[0] : 'All';
      }
    });
  }

  Future<List<String>> _fetchCategories() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('categories').get();

      // Extract category names from the documents
      final categories =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();

      // Add 'All' as the default category
      categories.insert(0, 'All');

      return categories;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching categories: $e")),
      );
      return ['All']; // Return a default list if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myappbar,
      appBar: AppBar(
        title: const Text("Manage Ice Cream Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addImage,
          ),
        ],
      ),
      body: _buildItemList(),
    );
  }
}
