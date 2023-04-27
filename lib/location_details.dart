
import 'package:flutter/material.dart';
import 'package:emergencies/emer_traking_page.dart';

class EmergencyLocationPage extends StatefulWidget {
  const EmergencyLocationPage({Key? key}) : super(key: key);

  @override
  State<EmergencyLocationPage> createState() => EmergencyLocationPageState();
}

class EmergencyLocationPageState extends State<EmergencyLocationPage> {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      title: 'Detailed Location',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      

      home: Data(),
      // home: ElevatedButton(child: Text("View Location on map"), onPressed: () {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  EmergencyTrackingPage() ));
      // },)
   );
  }
  
    
    
  
}





// class Data extends StatefulWidget {
//   const Data({Key? key}) : super(key: key);

//   @override
//   _DataState createState() => _DataState();
// }

// class _DataState extends State<Data> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: null,
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: MediaQuery.of(context).size.height / 2,
//             child: Image.asset(
//               'assets/map2.jpeg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: MediaQuery.of(context).size.height / 2,
//             child: Image.asset(
//               'assets/amb1.gif',
//               fit: BoxFit.fitHeight,
//               alignment: Alignment.bottomCenter,
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height / 4,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     '123 Main Street',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20.0,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Anytown, USA 12345',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 32.0),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     EmergencyTrackingPage()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.red,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 32.0, vertical: 16.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       child: Text(
//                         'View Location on Google maps',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Helvetica',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Image.asset(
              'assets/map2.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Image.asset(
              'assets/amb2.gif',
              fit: BoxFit.fitHeight,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'Area:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '123 Main Street',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 16.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Anytown, USA 12345',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmergencyTrackingPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'View Location on Google maps',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
