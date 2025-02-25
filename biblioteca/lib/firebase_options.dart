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
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCOWQjc4FKYEb-FwYQLBZ6JCT55dPfpMoI',
    appId: '1:221848962719:web:c28249d7898b80cbc544aa',
    messagingSenderId: '221848962719',
    projectId: 'biblioteca-flutter-80788',
    authDomain: 'biblioteca-flutter-80788.firebaseapp.com',
    storageBucket: 'biblioteca-flutter-80788.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDv_IYebIgmeXL2XyYKViNmxYxQDw5uN0',
    appId: '1:221848962719:android:3dcfaca1dd4df578c544aa',
    messagingSenderId: '221848962719',
    projectId: 'biblioteca-flutter-80788',
    storageBucket: 'biblioteca-flutter-80788.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqn7P3be_CB-LGK6TYd1dHO4NK7hEMY_U',
    appId: '1:221848962719:ios:ed13eb52ae30ef86c544aa',
    messagingSenderId: '221848962719',
    projectId: 'biblioteca-flutter-80788',
    storageBucket: 'biblioteca-flutter-80788.firebasestorage.app',
    iosBundleId: 'com.example.biblioteca',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqn7P3be_CB-LGK6TYd1dHO4NK7hEMY_U',
    appId: '1:221848962719:ios:ed13eb52ae30ef86c544aa',
    messagingSenderId: '221848962719',
    projectId: 'biblioteca-flutter-80788',
    storageBucket: 'biblioteca-flutter-80788.firebasestorage.app',
    iosBundleId: 'com.example.biblioteca',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCOWQjc4FKYEb-FwYQLBZ6JCT55dPfpMoI',
    appId: '1:221848962719:web:6f2dc65f4efd5132c544aa',
    messagingSenderId: '221848962719',
    projectId: 'biblioteca-flutter-80788',
    authDomain: 'biblioteca-flutter-80788.firebaseapp.com',
    storageBucket: 'biblioteca-flutter-80788.firebasestorage.app',
  );
}
