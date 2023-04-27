import 'package:emergencies/list.dart';
import 'package:emergencies/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth instance = FirebaseAuth.instance; 

  @override
  void initState() { 
    super.initState();
    instance.authStateChanges().listen((User? user ) { 
      if (user == null ){
          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Login(),
                          ),
                        );
      }

      else{
       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmergencyListPage(),
                          ),
                        );

      }
    });
      }
    
  

  @override
  Widget build(BuildContext context) {
    return Container();
  }


}


