// https://docs.flutter.dev/deployment/android  // for building the app for android

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:emergencies/home.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //opens channel to native api to firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
