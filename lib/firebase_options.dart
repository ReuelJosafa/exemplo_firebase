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
    apiKey: 'AIzaSyCCfzk8vZU9qISwRVUpmNHA8Uun8Cg3VoQ',
    appId: '1:703522820758:web:fb9491659b88415991e8b7',
    messagingSenderId: '703522820758',
    projectId: 'app-auth-teste-5deca',
    authDomain: 'app-auth-teste-5deca.firebaseapp.com',
    storageBucket: 'app-auth-teste-5deca.appspot.com',
    measurementId: 'G-SMBZT772NQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmCVs4E5NSx_-Sj4Uo_ydk0zeLLMvLoDk',
    appId: '1:703522820758:android:9878d95f22c17bca91e8b7',
    messagingSenderId: '703522820758',
    projectId: 'app-auth-teste-5deca',
    storageBucket: 'app-auth-teste-5deca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2RZne9lO-MGTj_D-suSt8KyYtLV6x7GI',
    appId: '1:703522820758:ios:dab577555b2f5c2591e8b7',
    messagingSenderId: '703522820758',
    projectId: 'app-auth-teste-5deca',
    storageBucket: 'app-auth-teste-5deca.appspot.com',
    iosClientId: '703522820758-h6jgsl916015ihjhas63b41ddig5t05c.apps.googleusercontent.com',
    iosBundleId: 'com.example.exemploFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2RZne9lO-MGTj_D-suSt8KyYtLV6x7GI',
    appId: '1:703522820758:ios:dab577555b2f5c2591e8b7',
    messagingSenderId: '703522820758',
    projectId: 'app-auth-teste-5deca',
    storageBucket: 'app-auth-teste-5deca.appspot.com',
    iosClientId: '703522820758-h6jgsl916015ihjhas63b41ddig5t05c.apps.googleusercontent.com',
    iosBundleId: 'com.example.exemploFirebase',
  );
}


