// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/category_chip.dart';
import 'package:samnang_ice_cream_roll/staff/model/cart_model.dart';
import 'package:samnang_ice_cream_roll/staff/pages/my_drawer.dart';
import 'package:samnang_ice_cream_roll/staff/pages/order_page.dart';
import 'package:samnang_ice_cream_roll/staff/pages/save_order_page.dart';
import 'package:samnang_ice_cream_roll/staff/pages/setting_page.dart';
import 'package:samnang_ice_cream_roll/staff/service/cart_service.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class HomeStuff extends StatefulWidget {
  const HomeStuff({super.key});

  @override
  State<HomeStuff> createState() => _HomeStuffState();
}

class _HomeStuffState extends State<HomeStuff> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  List<Map<String, dynamic>> _filteredItems = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _crossAxisCount = 2;
  int currentIndex = 0;
  bool _orderStarted = false; // Tracks if the order has started

  final Widget _currentPage = const HomeStuff();

  void _openSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          initialCrossAxisCount: _crossAxisCount,
          onCrossAxisCountChanged: (int count) {
            if (mounted) {
              setState(() {
                _crossAxisCount = count;
              });
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _filterByCategory(_selectedCategory);
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      final categories =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _categories = ['All', ...categories];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching categories: $e")),
      );
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });

    Future<List<Map<String, dynamic>>> getItemsByCategory(
        String category) async {
      Query query = _firestore.collection('menuItems');

      if (category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }

    getItemsByCategory(category).then((filteredItems) {
      setState(() {
        _filteredItems = filteredItems;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $error")),
      );
    });
  }

  void _filterBySearchQuery(String query) {
    if (query.isEmpty) {
      _filterByCategory(_selectedCategory);
      return;
    }

    setState(() {
      _filteredItems = _filteredItems
          .where((item) =>
              (item['name'] ?? '').toLowerCase().contains(query) ||
              (item['category'] ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  void _addToCart(Map<String, dynamic> item, CartProvider cartProvider) {
    if (!_orderStarted) {
      // Show dialog to start the order, but don’t add the item yet
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Start Order'),
            content: const Text('Would you like to start a new order?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog without starting
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close dialog
                  setState(() {
                    _orderStarted = true; // Mark order as started
                  });
                  final saleId = await generateSaleId();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SaveOrderPage(
                        saleId: saleId,
                        onStop: () {
                          setState(() {
                            _orderStarted = false; // Reset when stopped
                          });
                        },
                      ),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Order has started, add item to cart
      final cartItem = CartItem.fromMap(item);
      cartProvider.addItem(cartItem);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "${item['name']} added to cart",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> generateSaleId() async {
    final counterRef = _firestore.collection('metadata').doc('counters');

    try {
      final newCounter = await _firestore.runTransaction((transaction) async {
        final counterDoc = await transaction.get(counterRef);

        if (!counterDoc.exists) {
          transaction.set(counterRef, {'orderCounter': 1});
          return 1;
        }

        final currentCounter = counterDoc['orderCounter'] ?? 0;
        final incrementedCounter = currentCounter + 1;
        transaction.update(counterRef, {'orderCounter': incrementedCounter});
        return incrementedCounter;
      });

      return newCounter.toString().padLeft(4, '0');
    } catch (e) {
      throw Exception("Failed to generate Sale ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: MyColors.myappbar,
        actions: [
          _buildSearchBar(cartProvider),
          _buildCartIconWithBadge(cartProvider),
        ],
      ),
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradientColors,
        ),
        child: ListView(
          children: [
            _buildCategorySelector(),
            _buildItemGrid(cartProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(CartProvider cartProvider) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          onChanged: (query) {
            setState(() {
              _searchQuery = query.toLowerCase();
            });
            _filterBySearchQuery(_searchQuery);
          },
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.black38),
            hintText: 'Search...',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartIconWithBadge(CartProvider cartProvider) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const OrderPage()),
              ),
            ),
            if (cartProvider.cart.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    cartProvider.cart.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySelector() {
    if (_categories.length <= 1) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: MyColors.myappbar,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CategoryChip(
                name: "All",
                color: const Color.fromARGB(255, 78, 14, 215),
                onTap: () => _filterByCategory('All'),
              ),
              const SizedBox(width: 10),
              ..._categories
                  .where((category) => category != 'All')
                  .map((category) => [
                        CategoryChip(
                          name: category,
                          color: Colors.red,
                          onTap: () => _filterByCategory(category),
                        ),
                        const SizedBox(width: 10),
                      ])
                  .expand((chip) => chip)
                  .toList()
                ..removeLast(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemGrid(CartProvider cartProvider) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_filteredItems.isEmpty) {
      return const Center(
        child: Text(
          "No items available in this category.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4,
        ),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final itemData = _filteredItems[index];
          final imageUrl = itemData['image'];
          final name = itemData['name'];
          final price = itemData['price'];

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                _addToCart(itemData, cartProvider);
              },
              child: Column(
                children: [
                  Expanded(
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : const Icon(Icons.image, size: 100),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${price.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
