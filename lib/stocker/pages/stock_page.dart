import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/stocker/model/product_model.dart';
import 'package:samnang_ice_cream_roll/stocker/pages/add_product_screen.dart';
import 'package:samnang_ice_cream_roll/stocker/pages/cart_page_product.dart';
import 'package:samnang_ice_cream_roll/stocker/pages/edit_product_screen.dart';
import 'package:samnang_ice_cream_roll/stocker/pages/sale_product_screen.dart';
import 'package:samnang_ice_cream_roll/stocker/pages/sales_history_screen.dart';
import 'package:samnang_ice_cream_roll/stocker/service/cart_product_provider.dart';
import 'package:samnang_ice_cream_roll/stocker/service/product_provider.dart';
import 'package:samnang_ice_cream_roll/widgets/logout_page.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'ផ្លែឈើ',
    'នំ',
    'syrupe',
    'ទឹកដោះគោស្រស់',
    'ទឹកដោះគោកំប៉ុង',
    'ទឹកដោះគោខាប់',
    'កែវជ័រ',
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    List<Product> filteredProducts = _selectedCategory == 'All'
        ? productProvider.products
        : productProvider.products
            .where((product) => product.category == _selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        title: Text('Stock Management'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaleHistoryScreen(),
                ),
              );
            },
            icon: Icon(Icons.history),
          ),
          Consumer<CartProductProvider>(
            builder: (context, cartProvider, child) {
              final cartItemCount = cartProvider.cartItems.length;
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPageProduct(),
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart),
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartItemCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to home screen
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings screen
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                LogoutPage().logout(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: 'Filter by Category'),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('No products found'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ListTile(
                        leading: product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.image_not_supported,
                                size: 50,
                              ),
                        title: Text(
                          product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$${product.price}'),
                            Text('Stock: ${product.stock} ${product.unitType}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SellProductScreen(product: product),
                            ),
                          );
                        },
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              // Navigate to Edit Product Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProductScreen(product: product),
                                ),
                              );
                            } else if (value == 'add_stock') {
                              // Show dialog to add more stock
                              _showAddStockDialog(context, product);
                            } else if (value == 'delete') {
                              // Delete the product
                              _deleteProduct(context, product);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit Product'),
                              ),
                              PopupMenuItem(
                                value: 'add_stock',
                                child: Text('Add Stock'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Product'),
                              ),
                            ];
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Show dialog to add more stock
  void _showAddStockDialog(BuildContext context, Product product) {
    double additionalStock = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Stock to ${product.name}'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter additional stock'),
            onChanged: (value) {
              additionalStock = double.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newStock = product.stock + additionalStock;
                final productProvider =
                    Provider.of<ProductProvider>(context, listen: false);
                await productProvider.updateStock(product.id, newStock);
                await productProvider.fetchProducts();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Stock updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              },
              child: Text('Add Stock'),
            ),
          ],
        );
      },
    );
  }

  // Delete product
  void _deleteProduct(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${product.name}?'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete product from Firestore
                final productProvider =
                    Provider.of<ProductProvider>(context, listen: false);
                productProvider.deleteProduct(product.id);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
