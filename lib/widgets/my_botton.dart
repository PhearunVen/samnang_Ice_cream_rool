import 'package:flutter/material.dart';

class MyBotton extends StatelessWidget {
  const MyBotton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 530,
      left: 130,
      child: ElevatedButton(
        onPressed: () {
          // Handle sign-in action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 198, 189, 215), // Button color
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
