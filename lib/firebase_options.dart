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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCDuAOSaTTSA7qbfn1MqpVHr9GoFsci1Ts',
    appId: '1:907608334806:web:0764e877a22b7699458477',
    messagingSenderId: '907608334806',
    projectId: 'danaidapp',
    authDomain: 'danaidapp.firebaseapp.com',
    databaseURL: 'https://danaidapp.firebaseio.com',
    storageBucket: 'danaidapp.appspot.com',
    measurementId: 'G-JG65RKJPZL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuTqtXUYUf6h_OgkMD_6mkWWX-mgrY0xk',
    appId: '1:907608334806:android:85f68c998b6ee1ae458477',
    messagingSenderId: '907608334806',
    projectId: 'danaidapp',
    databaseURL: 'https://danaidapp.firebaseio.com',
    storageBucket: 'danaidapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUsoX_acWbd7fAqUMkJZdX8D0KAaJlDHo',
    appId: '1:907608334806:ios:36c8e467bb7bab57458477',
    messagingSenderId: '907608334806',
    projectId: 'danaidapp',
    databaseURL: 'https://danaidapp.firebaseio.com',
    storageBucket: 'danaidapp.appspot.com',
    androidClientId: '907608334806-32v357tbm1f2v7i429cs6916930iqlpi.apps.googleusercontent.com',
    iosClientId: '907608334806-d3utp81m2ss0um2hh1bt6hakl7maul4l.apps.googleusercontent.com',
    iosBundleId: 'com.danaidmobile.doctor',
  );
}
