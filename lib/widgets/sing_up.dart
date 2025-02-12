import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/widgets/my_colors.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showSignInPage;
  const SignUp({super.key, required this.showSignInPage});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Navigate to home page after registration (if necessary)
      } catch (e) {
        // Handle registration error, e.g., show a dialog
        //  print('Error registering: $e');
      }
    } else {
      // Show error message if passwords do not match
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    signUp();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 12.0; // Define the radius for the border

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: MyColors.gradient, // Use the gradient defined in MyColors
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // Spacing from the top if desired
              Center(
                child: Container(
                  width: 250,
                  height: 250,
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
              const SizedBox(height: 20),

              // "Sign Up" text
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Email text field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(radius), // Use defined radius
                  ),
                ),
              ),

              const SizedBox(height: 15), // Space between fields

              // Password text field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(radius), // Use defined radius
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(radius), // Use defined radius
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),

              // "Create Account" button with BorderRadius

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: signUp,
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: widget.showSignInPage,
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
