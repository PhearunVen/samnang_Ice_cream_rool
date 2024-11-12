import 'package:flutter/material.dart';
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
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_checkout_outlined),
                        onPressed: () {
                          // Add shopping cart functionality
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OrderPage()));
                        },
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 110, 51, 237),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'All',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Container for "Fruit"
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Fruit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Container for "Syrups"
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Syrups',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.count(
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    child: cardBox(
                        image: const AssetImage('assets/images/mongo.png'),
                        price: 2.5),
                  ),
                  Container(
                    child: cardBox(
                        image: const AssetImage('assets/images/mongo.png'),
                        price: 2.5),
                  ),
                  Container(
                    child: cardBox(
                        image: const AssetImage('assets/images/mongo.png'),
                        price: 2.5),
                  ),
                  Container(
                    child: cardBox(
                        image: const AssetImage('assets/images/mongo.png'),
                        price: 2.5),
                  ),
                  Container(
                    child: cardBox(
                        image: const AssetImage('assets/images/mongo.png'),
                        price: 2.5),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget cardBox({required ImageProvider image, required double price}) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
