import 'package:emergencies/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '', _password = '';
  FirebaseAuth instance = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, //AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Enter your email'),
              onChanged: (value) {
                setState(() {
                  this._email = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Enter your password'),
              onChanged: (value) {
                setState(() {
                  this._password = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async{
               try{
               UserCredential credential = await  instance.signInWithEmailAndPassword(email: _email, password: _password);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmergencyListPage()));

               
               } on FirebaseAuthException catch(e){
                   if(e.code == 'user-not-found'){
                    print("user not found ");
                   }    
                   
                   else if (e.code == 'wrong-password'){
                    print("wrong emil or password");
                   }
               }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
