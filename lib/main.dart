import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:samnang_ice_cream_roll/admin/pages/admin_page.dart';
import 'package:samnang_ice_cream_roll/firebase_options.dart';
import 'package:samnang_ice_cream_roll/staff/service/cart_service.dart';
import 'package:samnang_ice_cream_roll/stocker/service/cart_product_provider.dart';
import 'package:samnang_ice_cream_roll/stocker/service/product_provider.dart';
import 'package:samnang_ice_cream_roll/stocker/storage/data/firebase_strorage_stock_repo.dart';
import 'package:samnang_ice_cream_roll/storage/domain/storage_repo.dart';

import 'package:samnang_ice_cream_roll/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DevicePreview(
      enabled: true, // Set to `false` in production
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => CartProductProvider()),
          ChangeNotifierProvider(
            create: (_) => ProductProvider(),
          ),
          Provider<StorageRepo>(create: (_) => FirebaseStrorageStockRepo()),
        ],
        child: const MyApp(),
      ),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black87
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black38
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      // home: const SplashScreen(),
      home: AdminPage(),
    );
  }
}
