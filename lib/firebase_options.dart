// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAvv8wCXdFDZyAEM7M67RufM8kLckoxfUc',
    appId: '1:378008122097:web:84a72599116222428def50',
    messagingSenderId: '378008122097',
    projectId: 'syncz-791b7',
    authDomain: 'syncz-791b7.firebaseapp.com',
    storageBucket: 'syncz-791b7.appspot.com',
    measurementId: 'G-RPYHBVW2N7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB52_dqtpS-zPynBEPFkawKpjxBHrEXLKE',
    appId: '1:378008122097:android:f1111540b1294b268def50',
    messagingSenderId: '378008122097',
    projectId: 'syncz-791b7',
    storageBucket: 'syncz-791b7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2HMN-tg6OiLQOnyeQPNqbaQPsLurP4yM',
    appId: '1:378008122097:ios:5ed48b1ad9c977c88def50',
    messagingSenderId: '378008122097',
    projectId: 'syncz-791b7',
    storageBucket: 'syncz-791b7.appspot.com',
    iosClientId: '378008122097-vemuebf0c4jvo64t2j8em9aaec50otl9.apps.googleusercontent.com',
    iosBundleId: 'com.example.syncz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2HMN-tg6OiLQOnyeQPNqbaQPsLurP4yM',
    appId: '1:378008122097:ios:c7b4ceb0dc251f008def50',
    messagingSenderId: '378008122097',
    projectId: 'syncz-791b7',
    storageBucket: 'syncz-791b7.appspot.com',
    iosClientId: '378008122097-s8vopenjub4fds81nb1ijo9eebg6u98s.apps.googleusercontent.com',
    iosBundleId: 'com.example.syncz.RunnerTests',
  );
}
