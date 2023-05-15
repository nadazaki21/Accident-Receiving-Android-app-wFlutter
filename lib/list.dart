import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencies/emergency-call.dart';
import 'package:geocoding/geocoding.dart';
import 'package:emergencies/location_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emergencies/signin_page.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin, sin, pi, atan2;

class EmergenciesList extends StatefulWidget {
  @override
  _EmergenciesListState createState() => _EmergenciesListState();
}

class _EmergenciesListState extends State<EmergenciesList> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();
  double _distanceThreshold =
      10.0; // the maximum distance in kilometers allowed between current location and emergency location
  Position? _currentPosition; // holds the current user location

  Color _buttonColor =
      Colors.green; //which indicates whether this ambulance car is bbusy or not

  // method to get the current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  // method to calculate the distance between two locations in kilometers
  double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const int earthRadius = 6371; // in kilometers
    double dLat = _degreesToRadians(endLatitude - startLatitude);
    double dLon = _degreesToRadians(endLongitude - startLongitude);
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(startLatitude)) *
            cos(_degreesToRadians(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  // method to convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<String> getLocationFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  }

  // method to put emergency in its date page in date pciker
  Future<DateTime?> showDatePickerDialog(
      BuildContext context, DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
  }
  // method to logout

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SignInPage()),
    );
  }

  void _onButtonPressed() {
    setState(() {
      _buttonColor = _buttonColor == Colors.red ? Colors.green : Colors.red;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          ElevatedButton(
            onPressed: _onButtonPressed,
            child: Text('Change state'),
            style: ElevatedButton.styleFrom(primary: _buttonColor),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? pickedDate =
                  await showDatePickerDialog(context, selectedDate);
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('emergency-calls')
            .where('time', isGreaterThanOrEqualTo: selectedDate)
            .where('time',
                isLessThanOrEqualTo: selectedDate.add(Duration(days: 1)))
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.data == null) {
                return Text('No data found.');
              }
              List<ecall> _emergencies = snapshot.data!.docs
                  .map((doc) => ecall.fromJson(
                      doc.id, doc.data() as Map<String, dynamic>))
                  .toList();
              return ListView.builder(
                itemCount: _emergencies.length,
                itemBuilder: (BuildContext context, int index) {
                  double distance = _calculateDistance(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                    _emergencies[index].location.latitude,
                    _emergencies[index].location.longitude,
                  );
                  if (distance > _distanceThreshold) {
                    // Skip the item if the distance is greater than the threshold
                    return SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmergencyLocationPage(
                            documentId: _emergencies[index].id,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.car_repair),
                      ),
                      title: Text(_emergencies[index].title),
                      subtitle: FutureBuilder(
                        future: getLocationFromCoordinates(
                          _emergencies[index].location.latitude,
                          _emergencies[index].location.longitude,
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(snapshot.data!);
                          } else {
                            return Text('Loading location...');
                          }
                        },
                      ),
                      trailing: Text('${distance.toStringAsFixed(2)} km away'),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
