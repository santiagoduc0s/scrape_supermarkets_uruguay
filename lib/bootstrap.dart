import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:scrape_supermarkets_uruguay/src/src.dart';
import 'package:timezone/data/latest.dart';
// import 'package:scrape_supermarkets_uruguay/firebase_options.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await setup();

  runApp(await builder());
}

Future<void> setup() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await AppLifecycleHelper.instance.initialize();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  /// USE EMULATORS
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  await Preference.instance.initialize();
  await Security.instance.initialize();
  await Session.instance.initialize();
  await LocalNotificationHelper.instance.initialize();

  // final user = await AuthHelper.instance.getLoggedUserFromServer();
  // if (user != null) {
  //   Auth.instance.setUser(user);
  // }

  initializeTimeZones();

  FlutterNativeSplash.remove();
}
