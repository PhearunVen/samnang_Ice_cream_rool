import 'package:flutter/widgets.dart';
import 'package:samnang_ice_cream_roll/widgets/sign_in.dart';
import 'package:samnang_ice_cream_roll/widgets/sing_up.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showSignInPage = true;
  void toggleScreen() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignUp(showSignInPage: toggleScreen);
    } else {
      return SignIn(
        showSignUpPage: toggleScreen,
      );
    }
  }
}
