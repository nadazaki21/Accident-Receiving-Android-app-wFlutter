import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencies/current_location.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ecall {
  GeoPoint location;
  Timestamp time;
  String title;
  bool state;

  ecall({
    required this.location,
    required this.time,
    required this.title,
    this.state = false,
  });

  ecall.empty()
      : location = GeoPoint(0, 0),
        time = Timestamp.now(),
        title = '',
        state = false;

  factory ecall.fromJson(Map<String, dynamic> json) {
    return ecall(
      location: json['location'],
      time: json['time'],
      title: json['title'],
      state: json['state'] ?? false,
    );
  }
}



Future<ecall> readSingleEcall(String id) async {
  DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('emergency-calls').doc(id).get();
  return ecall.fromJson(doc.data()!);
}

Future<String> getLocation(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data();
  final geopoint = data?['location']['geopoint'];
  return geopoint != null ? '${geopoint.latitude},${geopoint.longitude}' : '';
}


Future<DateTime?> getTime(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data();
  final time = data?['time'] as Timestamp?;
  return time?.toDate();
}


Future<bool> getState(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data();
  return data?['state'] ?? false;
}

Future<String> getTitle(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data();
  return data?['title'] ?? '';
}


// toglle state code 
Future<void> toggleState(String docId) async {
  final documentRef = FirebaseFirestore.instance.collection('emergency-calls').doc(docId);
  final documentSnapshot = await documentRef.get();
  
  if (!documentSnapshot.exists) {
    throw Exception('Document does not exist!');
  }
  
  final currentState = documentSnapshot.data()!['state'] as bool;
  await documentRef.update({'state': !currentState});
}
