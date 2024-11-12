import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/widgets/sing_up.dart';
import 'package:samnang_ice_cream_roll/widgets/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSignInPage = true;
  void toggleScreen() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 182, 182, 241), // Start color
              Color.fromARGB(255, 222, 242, 215), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                  child: Container(
                    width: 250,
                    height: 270,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFEC8D8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.icecream,
                        size: 100,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
                // Sign In and Sign Up Buttons
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
                                  builder: (context) => SignIn(
                                        showSignUpPage: toggleScreen,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFCBC0E1), // Button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
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
                      const SizedBox(height: 20), // Space between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle sign-up action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp(
                                      showSignInPage: toggleScreen,
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFCBC0E1), // Button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
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
