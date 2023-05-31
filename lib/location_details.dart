import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:emergencies/emer_traking_page.dart';

class EmergencyLocationPage extends StatefulWidget {
  final String documentId;

  const EmergencyLocationPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<EmergencyLocationPage> createState() => EmergencyLocationPageState();
}

class EmergencyLocationPageState extends State<EmergencyLocationPage> {
  late String _documentId;
  late GeoPoint _location;
  String? _address;
  String? _phone;
  String? _Name;

  @override
  void initState() {
    super.initState();
    _documentId = widget.documentId;

    FirebaseFirestore.instance
        .collection('emergency-calls')
        .doc(_documentId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _location = documentSnapshot.get('location') ?? GeoPoint(0, 0);
          _phone = documentSnapshot.get('phone') ?? 'Unknown';
          _Name = documentSnapshot.get('Name') ?? 'Unknown';
        });
        _getAddressFromLocation();
      }
    });
  }

  void _navigateToTrackingPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmergencyTrackingPage(
          destLocation: _location,
          documentId: _documentId,
        ),
      ),
    );
  }

  Future<void> _getAddressFromLocation() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _location.latitude, _location.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}';
        setState(() {
          _address = address;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/map3.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 4,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      _address ?? 'Loading..',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _phone ?? 'Loading..',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _Name ?? 'Loading..',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _navigateToTrackingPage,
                      child: Text('View Location On Map'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _goBack,
                      child: Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
