import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:emergencies/constants.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';


var cl ; 

  Future getPosition( ) async {
    bool service ; 
    
    service = await Geolocator.isLocationServiceEnabled(); 
    print (service ); 
    LocationPermission per = LocationPermission.denied ; 
    if (service == true ){
      per = await Geolocator.checkPermission(); 
      print (per);

    }
    
    if ( per == LocationPermission.denied){
        per = await Geolocator.requestPermission();
      }

    if (per == LocationPermission.always){
      getLatAndLong();
    }
  }

  Future<Position> getLatAndLong() async{
    
     cl =  await Geolocator.getCurrentPosition().then((value) => value );
     print(cl.latitude);
     print(cl.longitude);

    return cl ; 

    
    
  
  }

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

    static  LatLng sourcelocation  = LatLng( cl.latitude , cl.longitude);
    static const  LatLng destlocation = LatLng( 30.0444, 31.2357);
    static  LatLng currentLocation = LatLng( cl.latitude , cl.longitude);
   List<LatLng> polylineCoordinates = [];
   
   // getting our own location 
  //  LocationData? currentLocation ; 

  //  void getCurrentLocation () async {
  //   Location location = Location ();
  //   location.getLocation().then((
  //     location)
  //     {
  //     currentLocation = location ; 
  //   },
  //   );

  //   GoogleMapController googleMapController = await _controller.future; 
    
  //   //change the current location as the physicallocation changes 
  //   location.onLocationChanged.listen((newLoc) {
  //       currentLocation = newLoc ; 

  //       googleMapController.animateCamera(CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //         zoom: 13.5,
  //         target: LatLng(newLoc.latitude!,
  //         newLoc.longitude!,
  //        )
  //       )
  //       ),
  //       );

  //       setState(() {});
  //   },);
  //  } 


    // put polyline value in the array 
    void getPolyPoints() async{

      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(google_api_key,
       PointLatLng(sourcelocation.latitude, sourcelocation.longitude),
        PointLatLng(destlocation.latitude,destlocation.longitude),
        );

        if(result.points.isNotEmpty){
          print("polyline points exist ");
          result.points.forEach(
          (PointLatLng point) =>
                    polylineCoordinates.add (
                      LatLng(point.latitude, point.longitude)
                      ),
          );

          setState ((){});
        }
    }
    
   
    void initState() { 
      //getCurrentLocation();
      getPolyPoints();
      super.initState();
      
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emergency Location",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: //currentLocation == null 
      //? const Center (child: Text ("Loading"))
      /*:*/ GoogleMap(
          initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation!.latitude! , currentLocation!.longitude!),
          zoom: 14.5
          ),
          polylines: {
            Polyline(
              polylineId: PolylineId("route"),
              points: polylineCoordinates,
              color: primaryColor,
              width: 6 
              ),

          },
          markers: {

            Marker(
              markerId:const MarkerId("currentLocation"),
              position: LatLng(
                currentLocation!.latitude!, 
                currentLocation!.longitude!) ,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

              
               ),

             Marker(
              markerId:MarkerId("source"),
              position: sourcelocation,
               ),

            const Marker(
              markerId:MarkerId("dest"),
              position: destlocation,
                ),
          },

          onMapCreated: (mapController)
          {
            _controller.complete(mapController);
          },
          ),

          
      );
    
        
  }
}
