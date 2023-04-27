// https://docs.flutter.dev/deployment/android  // for building the app for android 
import 'dart:developer';

import 'package:emergencies/list.dart';
import 'package:emergencies/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:emergencies/emer_traking_page.dart';
import 'package:emergencies/location_details.dart';
import 'package:emergencies/home.dart';
import 'package:intl/intl.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //opens channel to native api to firebase 
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
       home:  StreamBuilder<User?>(
        builder: (context , snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasData){
            return EmergencyListPage();
          }
          else if (snapshot.hasError){
            return Center(child:  Text("something went Wrong"));
          }
          else{
        return LoginWidget();}
       },
       stream: FirebaseAuth.instance.authStateChanges(),
       ),
    );
  }
}






