import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emergencies/emergency-call.dart';

int _currentIndex = 0;
late PageController _pageController;

@override
void initState() {
  initState();
  _pageController = PageController();
}

void dispose() {
  _pageController.dispose();
  dispose();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class EmergencyListPage extends StatefulWidget {
  const EmergencyListPage({Key? key}) : super(key: key);

  @override
  _EmergencyListPageState createState() => _EmergencyListPageState();
}

class _EmergencyListPageState extends State<EmergencyListPage> {
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('MMMM dd, yyyy');

  // the example for the list before fetching from firbase

  final List<Map<String, dynamic>> _emergencies = [
    {
      'time': '10:00 AM',
      'location': '123 Main Street',
      'description': 'Car crash with injuries',
      'status': 'Pending'
    },
    {
      'time': '2:30 PM',
      'location': '456 Oak Avenue',
      'description': 'Multi-car pileup',
      'status': 'In progress'
    },
    {
      'time': '7:15 PM',
      'location': '789 Elm Street',
      'description': 'Pedestrian hit by car',
      'status': 'Completed'
    }
  ];

  // after setting up fetching from firebase

  //   final List<ecall> _emergencies = [
  //   ecall(
  //     location: GeoPoint(40.7128, -74.0060),
  //     time: Timestamp.fromMillisecondsSinceEpoch(1649996400000),
  //     title: 'Car crash with injuries',
  //     state: false,
  //   ),
  //   ecall(
  //     location: GeoPoint(37.7749, -122.4194),
  //     time: Timestamp.fromMillisecondsSinceEpoch(1650014400000),
  //     title: 'Multi-car pileup',
  //     state: false,
  //   ),
  //   ecall(
  //     location: GeoPoint(34.0522, -118.2437),
  //     time: Timestamp.fromMillisecondsSinceEpoch(1650036000000),
  //     title: 'Pedestrian hit by car',
  //     state: false,
  //   ),
  // ];
  // fetching from firebase using the defined functions

  // method to read firebase documents

//  Stream<List<ecall>> readecall() => FirebaseFirestore.instance
//     .collection('emergency-call')
//     .snapshots()
//     .map((snapshot) => snapshot.doc.map((doc) => ecall.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
            }
          },
          child: Text(
            _dateFormat.format(_selectedDate),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),

      body:

          // using the written static list before setting up fetching from firebase

          ListView.builder(
        itemCount: _emergencies.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.car_repair),
            ),
            title: Text(_emergencies[index]['description']),
            subtitle: Text(
              '${_emergencies[index]['location']} - ${_emergencies[index]['time']}',
            ),
            trailing: Text(
              _emergencies[index]['status'],
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),

      // usuing the firbase field datatypes

//       ListView.builder(
//   itemCount: _emergencies.length,
//   itemBuilder: (BuildContext context, int index) {
//     final ecall = _emergencies[index];
//     final time = DateFormat('h:mm a').format(ecall.time.toDate());
//     final date = DateFormat('MMMM d, yyyy').format(ecall.time.toDate());
//     return ListTile(
//       leading: CircleAvatar(
//         child: Icon(Icons.car_repair),
//       ),
//       title: Text(ecall.title),
//       subtitle: Text(
//         '${ecall.location.latitude}, ${ecall.location.longitude}\n$time on $date',
//       ),
//       trailing: Text(
//         ecall.state ? 'Completed' : 'Pending',
//         style: TextStyle(
//           color: ecall.state ? Colors.green : Colors.blue,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   },
// ),
    );
  }
}
