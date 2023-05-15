import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:emergencies/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyTrackingPage extends StatefulWidget {
  final GeoPoint destLocation;
  final String documentId;

  const EmergencyTrackingPage(
      {Key? key, required this.destLocation, required this.documentId})
      : super(key: key);

  @override
  State<EmergencyTrackingPage> createState() => EmergencyTrackingPageState();
}

class EmergencyTrackingPageState extends State<EmergencyTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng sourceLocation = const LatLng(0, 0);
  LatLng currentLocation = const LatLng(0, 0);

  List<LatLng> polylineCoordinates = [];

  bool isLoading = true;
  bool positionObtained = false;

  Future<void> getPosition() async {
    print("Executing getPosition");
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled);

    LocationPermission permission = LocationPermission.denied;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (serviceEnabled == true) {
        permission = await Geolocator.checkPermission();
        print("Permission is $permission");
      }

      if (permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        print(position.latitude);
        print(position.longitude);

        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
          sourceLocation = currentLocation;
        });

        getPolyPoints();
        positionObtained = true;
      } else {
        positionObtained = false;
      }
    } else {
      positionObtained = false;
    }

    setState(() {
      isLoading = false;
    });

    print(currentLocation);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(widget.destLocation.latitude, widget.destLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      print("polyline points exist");
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('emergency-calls')
        .doc(widget.documentId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        GeoPoint location = documentSnapshot.get('location') ?? GeoPoint(0, 0);
        setState(() {
          sourceLocation = LatLng(location.latitude, location.longitude);
        });
      }
    });

    getPosition(); // Call getPosition() here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Location"),
      ),
      body: FutureBuilder(
        future: Future.value(positionObtained), // use positionObtained here
        builder: (context, snapshot) {
          if (isLoading || !positionObtained) {
            // check positionObtained here
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("An error occurred"));
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.destLocation.latitude, widget.destLocation.longitude),
              zoom: 14.5,
            ),
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: primaryColor,
                width: 6,
              ),
            },
            markers: {
              Marker(
                markerId: MarkerId("currentLocation"),
                position: currentLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                infoWindow: InfoWindow(title: "Current Location"),
                // Add a circle as a child of the marker
              ),
              Marker(
                markerId: MarkerId("dest"),
                position: LatLng(widget.destLocation.latitude,
                    widget.destLocation.longitude),
              ),
            },
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
          );
        },
      ),
    );
  }
}










// trying to draw a polyline 

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:emergencies/constants.dart';
// import 'package:emergencies/emergency-call.dart';
// import 'package:emergencies/emer_traking_page.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EmergencyTrackingPage extends StatefulWidget {
//   final GeoPoint destLocation;
//   final String documentId;

//   const EmergencyTrackingPage(
//       {Key? key, required this.destLocation, required this.documentId})
//       : super(key: key);

//   @override
//   State<EmergencyTrackingPage> createState() => EmergencyTrackingPageState();
// }

// class EmergencyTrackingPageState extends State<EmergencyTrackingPage> {
//   final Completer<GoogleMapController> _controller = Completer();

//   LatLng sourceLocation = const LatLng(0, 0);
//   LatLng currentLocation = const LatLng(0, 0);

//   List<LatLng> polylineCoordinates = [];

//   bool isLoading = true;
//   bool positionObtained = false;

//   Future<void> getPosition() async {
//     print("Executing getPosition");
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     print(serviceEnabled);

//     LocationPermission permission = LocationPermission.denied;
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();

//       if (serviceEnabled == true) {
//         permission = await Geolocator.checkPermission();
//         print("Permission is $permission");
//       }

//       if (permission == LocationPermission.always) {
//         final position = await Geolocator.getCurrentPosition();
//         print(position.latitude);
//         print(position.longitude);

//         setState(() {
//           currentLocation = LatLng(position.latitude, position.longitude);
//           sourceLocation = currentLocation;
//         });

//         positionObtained = true;
//       } else {
//         positionObtained = false;
//       }
//     } else {
//       positionObtained = false;
//     }

//     setState(() {
//       isLoading = false;
//     });

//     print(currentLocation);
//   }

//   PolylinePoints _polylinePoints = PolylinePoints();

//   Future<void> getPolyPoints() async {
//     PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
//       google_api_key,
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(widget.destLocation.latitude, widget.destLocation.longitude),
//     );

//     if (result != null && result.points.isNotEmpty) {
//       setState(() {
//         polylineCoordinates = result.points
//             .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
//             .toList();
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadEmergencyData();
//   }

//   Future<void> loadEmergencyData() async {
//     // Get the document snapshot
//     final documentSnapshot = await FirebaseFirestore.instance
//         .collection('emergency-calls')
//         .doc(widget.documentId)
//         .get();

//     if (documentSnapshot.exists) {
//       final location = documentSnapshot.get('location') ?? GeoPoint(0, 0);
//       setState(() {
//         sourceLocation = LatLng(location.latitude, location.longitude);
//       });
//     }

//     // Get the current location
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (serviceEnabled) {
//       final permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.always ||
//           permission == LocationPermission.whileInUse) {
//         final position = await Geolocator.getCurrentPosition();
//         setState(() {
//           currentLocation = LatLng(position.latitude, position.longitude);
//           sourceLocation = currentLocation;
//         });
//         positionObtained = true;
//       }
//     }

//     // Get the polyline points
//     if (positionObtained) {
//       final result = await _polylinePoints.getRouteBetweenCoordinates(
//         google_api_key,
//         PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//         PointLatLng(
//             widget.destLocation.latitude, widget.destLocation.longitude),
//       );
//       if (result != null && result.points.isNotEmpty) {
//         setState(() {
//           polylineCoordinates = result.points
//               .map((point) => LatLng(point.latitude, point.longitude))
//               .toList();
//         });
//       }
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Emergency Location"),
//         ),
//         body: isLoading || !positionObtained
//             ? Center(child: CircularProgressIndicator())
//             : GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: currentLocation,
//                   zoom: 14.5,
//                 ),
//                 polylines: {
//                   if (polylineCoordinates.isNotEmpty &&
//                       polylineCoordinates.length >= 2)
//                     Polyline(
//                       polylineId: PolylineId('route'),
//                       points: polylineCoordinates,
//                       color: Colors.red,
//                       width: 5,
//                     ),
//                 },
//                 markers: {
//                   Marker(
//                     markerId: MarkerId("currentLocation"),
//                     position: currentLocation,
//                     icon: BitmapDescriptor.defaultMarkerWithHue(
//                         BitmapDescriptor.hueCyan),
//                   ),
//                   Marker(
//                     markerId: MarkerId("source"),
//                     position: sourceLocation,
//                   ),
//                   Marker(
//                     markerId: MarkerId("dest"),
//                     position: LatLng(widget.destLocation.latitude,
//                         widget.destLocation.longitude),
//                   ),
//                 },
//                 onMapCreated: (mapController) {
//                   _controller.complete(mapController);
//                 },
//               ));
//   }
// }
