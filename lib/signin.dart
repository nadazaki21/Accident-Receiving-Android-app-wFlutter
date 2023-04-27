import 'package:emergencies/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: LoginWidget(),
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    //showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(),),barrierDismissible: false);
    try{
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim() , password: passwordController.text.trim(), );
    }
    on FirebaseAuthException catch (e){
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst );
    }
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    SingleChildScrollView(

      padding: EdgeInsets.all(16),
      child:  Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 120),

        Material(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Enter email'),
            ),
          ),
        ),

       Material(
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Password'),
          ),
        ),
      ),

        SizedBox(height: 20),
        ElevatedButton.icon(onPressed: signIn, style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        icon: Icon(Icons.lock_open, size: 32),
        label: Text('SignIn', style: TextStyle(fontSize:24),
        ),
        )
      ],),
    
    );
  }
}

