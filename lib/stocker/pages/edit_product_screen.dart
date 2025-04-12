import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/stocker/model/product_model.dart';
import 'package:samnang_ice_cream_roll/stocker/service/product_provider.dart';

import '../../storage/domain/storage_repo.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late double _stock;
  late String _unitType;
  late String _category;
  File? _imageFile;
  late String _imageUrl;
  final List<String> _categories = [
    'ផ្លែឈើ', // Fruits
    'នំ', // Cakes
    'syrupe', // Syrup
    'ទឹកដោះគោស្រស់', // Fresh Milk
    'ទឹកដោះគោកំប៉ុង', // Canned Milk
    'ទឹកដោះគោខាប់', // Condensed Milk
    'កែវជ័រ', // Jelly Cups
  ];

  final List<String> _unitTypes = [
    'កញ្ចប់', // Pack
    'កេស', // Case
    'ធុង', // Barrel
    'ដប', // Bottle
    'កំប៉ុង', // Can
    'ដុំ', // Piece
    'គីឡូ', // Kilogram
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _price = widget.product.price;
    _stock = widget.product.stock;
    _unitType = widget.product.unitType;
    _category = widget.product.category;
    _imageUrl = widget.product.imageUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRepo = Provider.of<StorageRepo>(context, listen: false);
    _imageUrl =
        (await storageRepo.uploadfileImageMobile(_imageFile!.path, fileName))!;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile == null
                      ? _imageUrl.isNotEmpty
                          ? Image.network(_imageUrl,
                              height: 150, width: 150, fit: BoxFit.cover)
                          : Icon(Icons.add_a_photo, size: 50)
                      : Image.file(_imageFile!,
                          height: 150, width: 150, fit: BoxFit.cover),
                ),
                SizedBox(height: 16),

                // Product Name Field
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  onChanged: (value) => _name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _price = double.tryParse(value) ?? 0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _stock.toString(),
                  decoration: InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _stock = double.tryParse(value) ?? 0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _unitType,
                  decoration: InputDecoration(labelText: 'Unit Type'),
                  items: _unitTypes.map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _unitType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a unit type';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _uploadImage(); // Upload image and get URL
                      final updatedProduct = Product(
                        id: widget.product.id,
                        name: _name,
                        price: _price,
                        stock: _stock,
                        unitType: _unitType,
                        category: _category,
                        imageUrl: _imageUrl, // Assign the image URL
                      );
                      productProvider.updateProduct(updatedProduct);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
