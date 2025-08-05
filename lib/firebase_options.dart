import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXffbNxCxmhztZGvc9plHKw92bjbOGgGI',
    appId: '1:965320825406:android:bbbaf94d1de1e1421ecf6f',
    messagingSenderId: '965320825406',
    projectId: 'emiraride-4ee4d',
    storageBucket: 'emiraride-4ee4d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'AIzaSyAW7IuhHma-RyQqeUqzkOgENONIY4AAaf8',
  appId: '1:965320825406:ios:24984f953bdc59101ecf6f',
  messagingSenderId: '965320825406',
  projectId: 'emiraride-4ee4d',
  storageBucket: 'emiraride-4ee4d.firebasestorage.app',
  androidClientId: '965320825406-8hb5b1q2jl19lq8l64bt8253kb2ugt4f.apps.googleusercontent.com',
  iosClientId: '965320825406-rfcmejh42gg4afloo1k02ug6vtj4pi9f.apps.googleusercontent.com',
  iosBundleId: 'com.inferloom.emiradriver',
);


}