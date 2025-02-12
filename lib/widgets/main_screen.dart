import 'package:flutter/material.dart';
import 'package:samnang_ice_cream_roll/util/responsive.dart';

class MainScreen extends StatelessWidget {
  final Widget? sideMenu;
  final Widget desboard;
  final Widget someOrder;

  const MainScreen({
    super.key,
    this.sideMenu,
    required this.desboard,
    required this.someOrder,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    return Scaffold(
      drawer: !isDesktop ? sideMenu : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SizedBox(child: sideMenu),
              ),
            Expanded(
              flex: 7,
              child: desboard,
            ),
            if (isDesktop || isTablet)
              Expanded(
                flex: 3,
                child: someOrder,
              ),
          ],
        ),
      ),
    );
  }
}
