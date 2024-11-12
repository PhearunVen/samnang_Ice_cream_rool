import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/pages/sale_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Use the gradient defined in MyColors
        ),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              accountName: Text(
                'Seller: ${user.email} ', // Replace with actual seller's name
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: const Text(
                'Position: Seller', // Replace with actual position if needed
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/seller/sell.jpg'), // Path to seller's image
              ),
            ),
            const Divider(
              // Add a divider below the header
              color: Colors.black, // Divider color
              thickness: 1, // Thickness of the divider
              indent: 16, // Start padding
              endIndent: 16, // End padding
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.money_off_csred_outlined),
              title: const Text('Sale'),
              onTap: () {
                // Add navigation logic here
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SalePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('About'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey,
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Row(
                        children: [
                          Image.asset(
                            'assets/images/mongo.png', // Path to the logo image
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'About Samnang ',
                                  // overflow: TextOverflow.ellipsis,
                                  // maxLines: 2,
                                ),
                                Text('Ice Cream Roll'),
                                Text(
                                  'v.1.1.0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      content: const SizedBox(
                        width: double.maxFinite, // Constrain the width
                        child: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Samnang Ice Cream Roll is a convenient app that allows customers to order delicious ice cream rolls directly from their mobile device.',
                              ),
                              SizedBox(height: 10),
                              Text(
                                'This app is designed to make the ordering process faster and easier while helping sellers keep track of orders and manage inventory efficiently. Enjoy fresh, customizable ice cream at the touch of a button!',
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 60,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 116, 32, 241),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Text(
                              'Cancle',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Messages'),
              onTap: () {
                // Add navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.notification_important_outlined),
              title: const Text('Notifications'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey,
                      title: const Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            size: 50,
                          ),
                          Text('  Notification'),
                        ],
                      ),
                      content: const Text(
                        'Do you want to turn on notifications?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 116, 32, 241),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add logic to turn on notifications here
                            Navigator.of(context)
                                .pop(); // Close the dialog after the action
                            // You can also show a Snackbar or another message to confirm
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notifications turned on!'),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 116, 32, 241),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Text(
                              'Turn on',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Spacer(), // Adds space above the Logout option
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
