// https://docs.flutter.dev/deployment/android  // for building the app for android

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:emergencies/home.dart';
import 'package:emergencies/emergency-call.dart';
import 'package:emergencies/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //opens channel to native api to firebase
  await Firebase.initializeApp();
  //listenToEmergencyCalls();
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<UserProvider>(
      create: (_) => UserProvider(), // Create an instance of UserProvider
      child: MaterialApp(
        title: 'My App',
        home: Home(),
      ),
      // return MaterialApp(
      //   home: Home(),
    );
  }
}
