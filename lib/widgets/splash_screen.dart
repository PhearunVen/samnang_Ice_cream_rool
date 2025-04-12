// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/admin/pages/admin_page.dart';
import 'package:samnang_ice_cream_roll/staff/pages/home_stuff.dart';
import 'package:samnang_ice_cream_roll/stocker/pages/stock_page.dart';
import 'package:samnang_ice_cream_roll/widgets/login_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showSignInPage = true;
  void toggleScreen() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  String? _storedEmail;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

// Retrieve email from local storage
  Future<String?> getStoredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // Check login status (e.g., for auto-login on app start)
  Future<void> checkLoginStatus() async {
    try {
      // Retrieve the stored email from local storage
      String? storedEmail = await getStoredEmail();
      setState(() {
        _storedEmail = storedEmail;
      });

      if (storedEmail != null && storedEmail.isNotEmpty) {
        // Fetch user data from Firestore using the stored email
        QuerySnapshot snapshot = await _firestore
            .collection('stores')
            .where('email', isEqualTo: storedEmail)
            .get();

        if (snapshot.docs.isNotEmpty) {
          var userDoc = snapshot.docs.first;
          String role = userDoc['role'];

          // Navigate based on the role
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
          } else if (role == 'staff') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeStuff()),
            );
          } else if (role == 'stocker') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StockPage()),
            );
          } else {
            Navigator.pop(context);
          }
        } else {
          // No matching email found
        }
      } else {
        // No stored email found, handle accordingly (e.g., stay on login page)
      }
    } catch (e) {
      // Handle any errors, such as network issues or Firestore errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: MyColors.gradientColors),
        child: Container(
          margin: const EdgeInsets.only(top: 120),
          child: Center(
            child: Stack(
              children: [
                // Staggered Text Design
                const Positioned(
                  top: 50,
                  left: 30,
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Cursive',
                    ),
                  ),
                ),
                const Positioned(
                  top: 100,
                  left: 100,
                  child: Text(
                    'to',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Positioned(
                  top: 150,
                  left: 100,
                  child: Text(
                    'ICE CREAM',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Positioned(
                  top: 200,
                  left: 250,
                  child: Text(
                    'Roll',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Ice cream illustration
                Positioned(
                  top: 230,
                  left: 60,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/ice-cream.png', // Path to your image asset
                      width: 250, // Width of the circular area
                      height: 270, // Height of the circular area
                      fit: BoxFit
                          .cover, // Ensures the image covers the circular area
                    ),
                  ),
                ),
                // Sign In Button (Conditional Visibility)
                if (_storedEmail == null) // Only show if not signed in
                  Positioned(
                    top: 530,
                    left: 130,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle sign-in action
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.mybutton,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
