// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQyoOLyqnU-6YY8Hb9qIyyO-jCO_lpCyI',
    appId: '1:580385448897:android:62d6c63172369f5bdf0540',
    messagingSenderId: '580385448897',
    projectId: 'instagram-ef80e',
    storageBucket: 'instagram-ef80e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-kiutqV_ehqVG8acyAewDI7gGPREME3s',
    appId: '1:580385448897:ios:1c4018ee31e6d541df0540',
    messagingSenderId: '580385448897',
    projectId: 'instagram-ef80e',
    storageBucket: 'instagram-ef80e.appspot.com',
    iosBundleId: 'com.example.samnangIceCreamRoll',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAgbpzLVEkJOgIMhZws8z82iiBrWZUAlBY',
    appId: '1:421174144787:web:1d9b22b6e2a14ee0ad74e6',
    messagingSenderId: '421174144787',
    projectId: 'myicecream-89f8d',
    authDomain: 'myicecream-89f8d.firebaseapp.com',
    storageBucket: 'myicecream-89f8d.firebasestorage.app',
    measurementId: 'G-57R557FE53',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB6psq5cVpRf4D1SpNVh45CsBygWYuC5PA',
    appId: '1:580385448897:web:8a72dbb5fa8453cddf0540',
    messagingSenderId: '580385448897',
    projectId: 'instagram-ef80e',
    authDomain: 'instagram-ef80e.firebaseapp.com',
    storageBucket: 'instagram-ef80e.appspot.com',
    measurementId: 'G-S70BPE2FVJ',
  );

}