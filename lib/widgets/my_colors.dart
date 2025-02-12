import 'package:flutter/material.dart';

class MyColors {
  static const mybutton = Color.fromRGBO(245, 201, 217, 1.0);
  static const myappbar = Color.fromRGBO(206, 187, 250, 1.0);
  // Define a LinearGradient property
  static const LinearGradient gradient = LinearGradient(
    colors: [
      Color.fromRGBO(206, 187, 250, 1.0), // #CEBBFA
      Color.fromRGBO(245, 201, 217, 1.0), // #F5C9D9
      Color.fromRGBO(182, 238, 227, 1), // #97E1D4
    ],
    stops: [0.0, 0.8, 1.1],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
  static const LinearGradient gradientCategory = LinearGradient(
    colors: [
      Color.fromRGBO(206, 187, 250, 1.0), // #CEBBFA
      Color.fromRGBO(245, 201, 217, 1.0), // #F5C9D9
      Color.fromRGBO(182, 238, 227, 1), // #97E1D4
    ],
    stops: [0.5, 0.85, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
  static const LinearGradient gradientColors = LinearGradient(
    colors: [
      Color.fromRGBO(206, 187, 250, 1.0), // #CEBBFA
      Color.fromRGBO(245, 201, 217, 1.0), // #F5C9D9
      Color.fromRGBO(182, 238, 227, 1), // #97E1D4
    ],
    stops: [0.5, 0.85, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
  );
}
