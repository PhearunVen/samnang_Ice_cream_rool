import 'package:flutter/material.dart';

class MyColors {
  // Define a LinearGradient property
  static const LinearGradient gradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 182, 182, 241), // Start color
      Color.fromARGB(255, 222, 242, 215), // End color
    ],
    begin: Alignment.topLeft, // You can customize the direction of the gradient
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientCategory = LinearGradient(
    colors: [
      // Start color
      Color.fromARGB(255, 73, 17, 185),
      // End color
      Color.fromARGB(255, 189, 112, 236),
    ],
    begin:
        Alignment.topRight, // You can customize the direction of the gradient
    end: Alignment.bottomLeft,
  );
  // You can add more colors or gradients here as needed
}
