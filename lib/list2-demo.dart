// with logout button 

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emergencies/emergency-call.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:emergencies/location_details.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:emergencies/signin_page.dart';

// class EmergenciesList extends StatefulWidget {
//   @override
//   _EmergenciesListState createState() => _EmergenciesListState();
// }

// class _EmergenciesListState extends State<EmergenciesList> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   DateTime selectedDate = DateTime.now();
//   Future<String> getLocationFromCoordinates(
//       double latitude, double longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     Placemark place = placemarks[0];
//     return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//   }

//   // method to put emergency in its date page in date pciker
//   Future<DateTime?> showDatePickerDialog(
//       BuildContext context, DateTime initialDate) async {
//     return showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2010),
//       lastDate: DateTime.now(),
//     );
//   }
//   // method to logout

//   Future<void> logout() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (BuildContext context) => SignInPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Emergencies List'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: logout,
//           ),
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: () async {
//               final DateTime? pickedDate =
//                   await showDatePickerDialog(context, selectedDate);
//               if (pickedDate != null && pickedDate != selectedDate) {
//                 setState(() {
//                   selectedDate = pickedDate;
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _db
//             .collection('emergency-calls')
//             .where('time', isGreaterThanOrEqualTo: selectedDate)
//             .where('time',
//                 isLessThanOrEqualTo: selectedDate.add(Duration(days: 1)))
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(child: CircularProgressIndicator());
//             default:
//               List<ecall> _emergencies = snapshot.data!.docs
//                   .map((doc) => ecall.fromJson(
//                       doc.id, doc.data() as Map<String, dynamic>))
//                   .toList();

//               return ListView.builder(
//                 itemCount: _emergencies.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EmergencyLocationPage(
//                             documentId: _emergencies[index].id,
//                           ),
//                         ),
//                       );
//                     },
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         child: Icon(Icons.car_repair),
//                       ),
//                       title: Text(_emergencies[index].title),
//                       subtitle: FutureBuilder(
//                         future: getLocationFromCoordinates(
//                           _emergencies[index].location.latitude,
//                           _emergencies[index].location.longitude,
//                         ),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<String> locationSnapshot) {
//                           if (locationSnapshot.hasData) {
//                             return Text(locationSnapshot.data!);
//                           } else {
//                             return Text('Loading...');
//                           }
//                         },
//                       ),
//                       trailing: FutureBuilder(
//                         future: getState(_emergencies[index].id),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<bool> stateSnapshot) {
//                           if (stateSnapshot.hasData) {
//                             return Text(
//                               stateSnapshot.data! ? 'In progress' : 'Pending',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             );
//                           } else {
//                             return Text('Loading...');
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               );
//           }
//         },
//       ),
//     );
//   }
// }








// with functioning datepicker

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emergencies/emergency-call.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:emergencies/location_details.dart';

// class EmergenciesList extends StatefulWidget {
//   @override
//   _EmergenciesListState createState() => _EmergenciesListState();
// }

// class _EmergenciesListState extends State<EmergenciesList> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   DateTime selectedDate = DateTime.now();
//   Future<String> getLocationFromCoordinates(
//       double latitude, double longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     Placemark place = placemarks[0];
//     return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//   }

//   // method to put emergency in its date page in date pciker
//   Future<DateTime?> showDatePickerDialog(
//       BuildContext context, DateTime initialDate) async {
//     return showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2010),
//       lastDate: DateTime.now(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Emergencies List'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: () async {
//               final DateTime? pickedDate =
//                   await showDatePickerDialog(context, selectedDate);
//               if (pickedDate != null && pickedDate != selectedDate) {
//                 setState(() {
//                   selectedDate = pickedDate;
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _db
//             .collection('emergency-calls')
//             .where('time', isGreaterThanOrEqualTo: selectedDate)
//             .where('time',
//                 isLessThanOrEqualTo: selectedDate.add(Duration(days: 1)))
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(child: CircularProgressIndicator());
//             default:
//               List<ecall> _emergencies = snapshot.data!.docs
//                   .map((doc) => ecall.fromJson(
//                       doc.id, doc.data() as Map<String, dynamic>))
//                   .toList();

//               return ListView.builder(
//                 itemCount: _emergencies.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EmergencyLocationPage(
//                             documentId: _emergencies[index].id,
//                           ),
//                         ),
//                       );
//                     },
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         child: Icon(Icons.car_repair),
//                       ),
//                       title: Text(_emergencies[index].title),
//                       subtitle: FutureBuilder(
//                         future: getLocationFromCoordinates(
//                           _emergencies[index].location.latitude,
//                           _emergencies[index].location.longitude,
//                         ),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<String> locationSnapshot) {
//                           if (locationSnapshot.hasData) {
//                             return Text(locationSnapshot.data!);
//                           } else {
//                             return Text('Loading...');
//                           }
//                         },
//                       ),
//                       trailing: FutureBuilder(
//                         future: getState(_emergencies[index].id),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<bool> stateSnapshot) {
//                           if (stateSnapshot.hasData) {
//                             return Text(
//                               stateSnapshot.data! ? 'In progress' : 'Pending',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             );
//                           } else {
//                             return Text('Loading...');
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               );
//           }
//         },
//       ),
//     );
//   }
// }

// without date picker

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:emergencies/emergency-call.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:emergencies/location_details.dart';

// class EmergenciesList extends StatefulWidget {
//   @override
//   _EmergenciesListState createState() => _EmergenciesListState();
// }

// class _EmergenciesListState extends State<EmergenciesList> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<String> getLocationFromCoordinates(
//       double latitude, double longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     Placemark place = placemarks[0];
//     return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _db.collection('emergency-calls').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(child: CircularProgressIndicator());
//             default:
//               List<ecall> _emergencies = snapshot.data!.docs
//                   .map((doc) => ecall.fromJson(
//                       doc.id, doc.data() as Map<String, dynamic>))
//                   .toList();

//               return ListView.builder(
//                 itemCount: _emergencies.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EmergencyLocationPage(
//                             documentId: _emergencies[index].id,
//                           ),
//                         ),
//                       );
//                     },
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         child: Icon(Icons.car_repair),
//                       ),
//                       title: Text(_emergencies[index].title),
//                       subtitle: FutureBuilder(
//                         future: getLocationFromCoordinates(
//                           _emergencies[index].location.latitude,
//                           _emergencies[index].location.longitude,
//                         ),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<String> locationSnapshot) {
//                           if (locationSnapshot.hasData) {
//                             return Text(locationSnapshot.data!);
//                           } else {
//                             return Text('Loading...');
//                           }
//                         },
//                       ),
//                       trailing: FutureBuilder(
//                         future: getState(_emergencies[index].id),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<bool> stateSnapshot) {
//                           if (stateSnapshot.hasData) {
//                             return Text(
//                               stateSnapshot.data! ? 'In progress' : 'Pending',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             );
//                           } else {
//                             return Text('Loading...');
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               );
//           }
//         },
//       ),
//     );
//   }
// }

// notification not working code

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:emergencies/emergency-call.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class EmergenciesList extends StatefulWidget {
//   @override
//   _EmergenciesListState createState() => _EmergenciesListState();
// }

// class _EmergenciesListState extends State<EmergenciesList> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   Future<String> getLocationFromCoordinates(
//       double latitude, double longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     Placemark place = placemarks[0];
//     return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//   }

//   @override
//   void initState() {
//     super.initState();

//     var initializationSettingsAndroid =
//         new AndroidInitializationSettings('app_icon');
//     var initializationSettings =
//         new InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _showNotification(String title, String message) async {
//     var androidDetails = new AndroidNotificationDetails(
//         "New Emergency", "Car Crash Occured",
//         importance: Importance.high);
//     var generalNotificationDetails =
//         new NotificationDetails(android: androidDetails);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       message,
//       generalNotificationDetails,
//       payload: 'New Emergency Call'.toString(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _db.collection('emergency-calls').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(child: CircularProgressIndicator());
//             default:
//               List<ecall> _emergencies = snapshot.data!.docs
//                   .map((doc) => ecall.fromJson(
//                       doc.id, doc.data() as Map<String, dynamic>))
//                   .toList();

//               _showNotification("New Emergency Call",
//                   "A new emergency call has been added to the list.");

//               return ListView.builder(
//                 itemCount: _emergencies.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(
//                     leading: CircleAvatar(
//                       child: Icon(Icons.car_repair),
//                     ),
//                     title: Text(_emergencies[index].title),
//                     subtitle: FutureBuilder(
//                       future: getLocationFromCoordinates(
//                         _emergencies[index].location.latitude,
//                         _emergencies[index].location.longitude,
//                       ),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<String> locationSnapshot) {
//                         if (locationSnapshot.hasData) {
//                           return Text(locationSnapshot.data!);
//                         } else {
//                           return Text('Loading...');
//                         }
//                       },
//                     ),
//                     trailing: FutureBuilder(
//                       future: getState(_emergencies[index].id),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<bool> stateSnapshot) {
//                         if (stateSnapshot.hasData) {
//                           return Text(
//                             stateSnapshot.data! ? 'In progress' : 'Pending',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           );
//                         } else {
//                           return Text('Loading...');
//                         }
//                       },
//                     ),
//                   );
//                 },
//               );
//           }
//         },
//       ),
//     );
//   }
// }
