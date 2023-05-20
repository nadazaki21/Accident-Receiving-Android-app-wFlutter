import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencies/current_location.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class ecall {
//   String id;
//   GeoPoint location;
//   Timestamp time;
//   String title;
//   bool state;
//   late String? viewedby;

//   ecall({
//     required this.id,
//     required this.location,
//     required this.time,
//     required this.title,
//     this.state = false,
//     this.viewedby,
//   });

//   ecall.empty()
//       : id = '',
//         location = GeoPoint(0, 0),
//         time = Timestamp.now(),
//         title = '',
//         state = false;
//         viewedby = null;

//   factory ecall.fromJson(String documentId, Map<String, dynamic> json) {
//     // add documentId argument
//     return ecall(
//       id: documentId,
//       location: json['location'],
//       time: json['time'],
//       title: json['title'],
//       state: json['state'] ?? false,
//       viewedby: viewedby,
//     );
//   }
// }

class ecall {
  String id;
  GeoPoint location;
  Timestamp time;
  String title;
  bool state;
  String? viewedby;

  ecall({
    required this.id,
    required this.location,
    required this.time,
    required this.title,
    this.state = false,
    this.viewedby,
  });

  ecall.empty()
      : id = '',
        location = GeoPoint(0, 0),
        time = Timestamp.now(),
        title = '',
        state = false,
        viewedby = null;

  factory ecall.fromJson(String documentId, Map<String, dynamic> json) {
    // add documentId argument
    final viewedBy = json['viewedby'] ?? null;
    return ecall(
      id: documentId,
      location: json['location'],
      time: json['time'],
      title: json['title'],
      state: json['state'] ?? false,
      viewedby: viewedBy,
    );
  }
}

Future<ecall> readSingleEcall(String id) async {
  DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(id)
      .get();
  Map<String, dynamic>? data = doc.data();
  return ecall.fromJson(id, {
    ...data!,
  });
}

Future<String> getLocation(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data() as Map<String, dynamic>?;

  final geopoint = data?['location']['geopoint'];
  return geopoint != null ? '${geopoint.latitude},${geopoint.longitude}' : '';
}

Future<DateTime?> getTime(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data() as Map<String, dynamic>?;

  final time = data?['time'] as Timestamp?;
  return time?.toDate();
}

Future<bool> getState(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data() as Map<String, dynamic>?;

  return data?['state'] ?? false;
}

Future<String> getTitle(String docId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('emergency-calls')
      .doc(docId)
      .get();
  final data = snapshot.data() as Map<String, dynamic>?;

  return data?['title'] ?? '';
}

// toglle state code
Future<void> toggleState(String docId) async {
  final documentRef =
      FirebaseFirestore.instance.collection('emergency-calls').doc(docId);
  final documentSnapshot = await documentRef.get();

  if (!documentSnapshot.exists) {
    throw Exception('Document does not exist!');
  }

  final currentState = documentSnapshot.data()!['state'] as bool;
  await documentRef.update({'state': !currentState});
}

// Checking if "viewedby" field exists for each document

// Future<void> fetchEmergencyCalls() async {
//   CollectionReference ecallCollection =
//       FirebaseFirestore.instance.collection('emergency-calls');

//   QuerySnapshot querySnapshot = await ecallCollection.get();

//   List<ecall> ecallList = querySnapshot.docs.map((DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//     if (!data.containsKey('viewedby')) {
//       return ecall(
//         id: document.id,
//         location: data['location'],
//         time: data['time'],
//         title: data['title'],
//         state: data['state'] ?? false,
//         viewedby: null,
//       );
//     }

//     return ecall(
//       id: document.id,
//       location: data['location'],
//       time: data['time'],
//       title: data['title'],
//       state: data['state'] ?? false,
//       viewedby: data['viewedby'],
//     );
//   }).toList();
// }

// void listenToEmergencyCalls() {
//   CollectionReference ecallCollection =
//       FirebaseFirestore.instance.collection('emergency-calls');

//   ecallCollection.snapshots().listen((QuerySnapshot querySnapshot) {
//     querySnapshot.docChanges.forEach((DocumentChange documentChange) {
//       if (documentChange.type == DocumentChangeType.added) {
//         DocumentSnapshot document = documentChange.doc;
//         Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//         if (!data.containsKey('viewedby')) {
//           // 'viewedby' field is missing, add it with a default value
//           ecallCollection.doc(document.id).update({'viewedby': null});
//         }
//       }
//     });
//   });
// }
