// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:samnang_ice_cream_roll/admin/pages/admin_page.dart';
import 'package:samnang_ice_cream_roll/staff/pages/home_stuff.dart';
import 'package:samnang_ice_cream_roll/stocker/pages/stock_page.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      EasyLoading.showError('Please enter email and password');
      return;
    }

    EasyLoading.show(
        status: 'Verifying...', maskType: EasyLoadingMaskType.black);

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('stores')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) {
        EasyLoading.showError('Email not found');
        return;
      }

      var userDoc = snapshot.docs.first;
      String storedPassword = userDoc['password'];

      if (storedPassword != _passwordController.text.trim()) {
        EasyLoading.showError('Incorrect password');
        return;
      }

      // Store login and navigate
      String role = userDoc['role'];
      await storeEmail(userDoc['email']);

      EasyLoading.showSuccess('Welcome, $role!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => role == 'admin'
              ? const AdminPage()
              : role == 'staff'
                  ? const HomeStuff()
                  : StockPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      EasyLoading.showError('Login failed: ${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Store email in local storage after successful login
  Future<void> storeEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: MyColors.gradientColors,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
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
              const SizedBox(height: 20),
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: signIn,
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
