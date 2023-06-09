import 'package:emergencies/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emergencies/list.dart';
import 'package:emergencies/draft.dart';

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
    instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmergenciesList(),
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








// import 'package:emergencies/signin_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:emergencies/list.dart';
// import 'package:emergencies/draft.dart';
// import 'package:provider/provider.dart';
// import 'package:emergencies/user_provider.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   FirebaseAuth instance = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SignInPage(),
//           ),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChangeNotifierProvider(
//               create: (_) => UserProvider(),
//               child: EmergenciesList(),
//             ),
//           ),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
