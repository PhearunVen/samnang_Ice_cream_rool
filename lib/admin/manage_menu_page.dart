import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class ManageMenuPage extends StatefulWidget {
  const ManageMenuPage({super.key});

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  final List<MenuItem> _menuItems = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDefaultMenuItems();
  }

  void _initializeDefaultMenuItems() {
    _menuItems.addAll([
      MenuItem(
        title: 'Espresso',
        price: 2.50,
        image: 'assets/images/mongo.png', // Corrected to match the file name
      ),
      MenuItem(
        title: 'Latte',
        price: 3.50,
        image: 'assets/images/mongo.png', // Replace with your image file
      ),
      MenuItem(
        title: 'Cappuccino',
        price: 3.00,
        image: 'assets/images/mongo.png', // Replace with your image file
      ),
      MenuItem(
        title: 'Mocha',
        price: 3.75,
        image: 'assets/images/mongo.png', // Replace with your image file
      ),
      MenuItem(
        title: 'Black Coffee',
        price: 2.00,
        image: 'assets/images/mongo.png', // Replace with your image file
      ),
    ]);
  }

  void _addMenuItem() {
    final String title = _titleController.text;
    final String priceStr = _priceController.text;
    final String image = _imageController.text;

    if (title.isNotEmpty && priceStr.isNotEmpty && image.isNotEmpty) {
      final double price = double.tryParse(priceStr) ?? 0;
      setState(() {
        _menuItems.add(MenuItem(title: title, price: price, image: image));
      });

      _titleController.clear();
      _priceController.clear();
      _imageController.clear();
      Navigator.pop(context); // Close the dialog
    }
  }

  void _showAddMenuItemDialog() {
    _titleController.clear();
    _priceController.clear();
    _imageController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Menu Item'),
          content: _buildDialogContent(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _addMenuItem,
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMenuItemDialog(int index) {
    final item = _menuItems[index];

    _titleController.text = item.title;
    _priceController.text = item.price.toString();
    _imageController.text = item.image;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Menu Item'),
          content: _buildDialogContent(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editMenuItem(index);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Item Title'),
        ),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Item Price'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _imageController,
          decoration: const InputDecoration(labelText: 'Image Path'),
        ),
      ],
    );
  }

  void _editMenuItem(int index) {
    final String title = _titleController.text;
    final String priceStr = _priceController.text;
    final String image = _imageController.text;

    if (title.isNotEmpty && priceStr.isNotEmpty && image.isNotEmpty) {
      final double price = double.tryParse(priceStr) ?? 0;
      setState(() {
        _menuItems[index] = MenuItem(title: title, price: price, image: image);
      });
    }
  }

  void _deleteMenuItem(int index) {
    setState(() {
      _menuItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Menu'),
        backgroundColor: const Color.fromARGB(0, 230, 94, 94),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMenuItemDialog,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Apply the gradientCategory here
        ),
        child: ListView.builder(
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final item = _menuItems[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.image,
                          width: 80, // Set the width of the image
                          height: 80, // Set the height of the image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditMenuItemDialog(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteMenuItem(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final double price;
  final String image;

  MenuItem({required this.title, required this.price, required this.image});
}
