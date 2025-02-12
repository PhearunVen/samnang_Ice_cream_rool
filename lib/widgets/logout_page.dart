// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';

class LogoutPage {
  Future<void> logout(BuildContext context) async {
    // Show the loading indicator
    EasyLoading.show(
      status: 'Logging out...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      // Add a delay (e.g., simulating logout or clearing session)
      await Future.delayed(const Duration(seconds: 2));

      // Clear user email and other related data from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.clear();

      // Dismiss the loading indicator
      EasyLoading.dismiss();

      // Navigate back to the SplashScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } catch (e) {
      // Dismiss the loading indicator in case of error
      EasyLoading.dismiss();

      // Log the error for debugging
      debugPrint('Logout error: $e');

      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while logging out.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
