import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/model/ice_cream_Item.dart';
import 'package:samnang_ice_cream_roll/model/my_ice_cream_item.dart';
import 'package:samnang_ice_cream_roll/pages/ice_cream_cart.dart';
import 'package:samnang_ice_cream_roll/pages/my_drawer.dart';
import 'package:samnang_ice_cream_roll/pages/order_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class HomeStuff extends StatefulWidget {
  const HomeStuff({
    super.key,
  });

  @override
  State<HomeStuff> createState() => _HomeStuffState();
}

class _HomeStuffState extends State<HomeStuff> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int cartItemCount = 0;
  int isSelected = 0;
  // Function to simulate adding items to the cart
  void addToCart() {
    setState(() {
      cartItemCount++; // Increment cart item count
    });
    //  print("Item added to cart. Total items: $cartItemCount"); // Debugging line
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the global key to Scaffold
      drawer: const MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Use the gradient defined in MyColors
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black38),
                  hintText: 'Search...',
                  prefixIcon: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer(); // Open drawer
                    },
                    icon: const Icon(Icons.menu),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Add search functionality
                        },
                      ),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined),
                            onPressed: () {
                              // Navigate to the order page or cart page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OrderPage()));
                            },
                          ),
                          if (cartItemCount >
                              0) // Only show the badge if the count is greater than 0
                            Positioned(
                              right: 5, // Adjust the position of the badge
                              top: 2,
                              child: GestureDetector(
                                onTap: () {
                                  // Optional: Add functionality for tapping the badge (e.g., open cart)
                                },
                                child: Container(
                                  width: 15,
                                  height: 20,
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$cartItemCount', // Display the dynamic cart count
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                gradient: MyColors.gradientCategory,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Container for "All"
                    builAllIceCreamItem(
                        index: 0, name: "All", color: Colors.purple),
                    // Container for "Fruit"
                    builAllIceCreamItem(
                        index: 1, name: "Fruit", color: Colors.red),
                    // Container for "Syrups"
                    builAllIceCreamItem(
                        index: 2, name: "Syrups", color: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  200, // Adjust height as needed
              child: isSelected == 0
                  ? buildAllIceCreamItem()
                  : isSelected == 1
                      ? buildFruitIceCreamItem()
                      : buildSyrupsIceCreamItem(),
            ),
          ],
        ),
      ),
    );
  }

  builAllIceCreamItem({
    required int index,
    required String name,
    required Color color,
  }) =>
      InkWell(
        onTap: () => setState(() => isSelected = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );

  buildAllIceCreamItem() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: (100 / 140),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        scrollDirection: Axis.vertical,
        itemCount: MyIceCreamItem.allIceCreamItem.length,
        itemBuilder: (context, index) {
          final allIceCreamItem = MyIceCreamItem.allIceCreamItem[index];
          return GestureDetector(
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DetailsScreen(product: allProducts))),
            child: IceCreamCart(
              iceCreamItem: allIceCreamItem,
            ),
          );
        },
      );

  buildFruitIceCreamItem() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: (100 / 140),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        scrollDirection: Axis.vertical,
        itemCount: MyIceCreamItem.fruitIceCreamItem.length,
        itemBuilder: (context, index) {
          final fruitIceCreamItem = MyIceCreamItem.fruitIceCreamItem[index];
          return GestureDetector(
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DetailsScreen(product: allProducts))),
            child: IceCreamCart(
              iceCreamItem: fruitIceCreamItem,
            ),
          );
        },
      );

  buildSyrupsIceCreamItem() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: (100 / 140),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        scrollDirection: Axis.vertical,
        itemCount: MyIceCreamItem.syrupsIceCreamItem.length,
        itemBuilder: (context, index) {
          final syrupsIceCreamItem = MyIceCreamItem.syrupsIceCreamItem[index];
          return GestureDetector(
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DetailsScreen(product: allProducts))),
            child: IceCreamCart(
              iceCreamItem: syrupsIceCreamItem,
            ),
          );
        },
      );
}
