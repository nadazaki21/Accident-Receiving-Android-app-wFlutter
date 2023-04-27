// import 'dart:async';
// //import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// //import 'package:flutter_svg/flutter_svg.dart';
// import 'package:emergencies/constants.dart';
// //import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';



//  var cl ; 

//  LatLng sourcelocation  = LatLng( 0 , 0) ;
//      const  LatLng destlocation = LatLng( 30.0444, 31.2357);
//      LatLng currentLocation = LatLng( 0,0 );

  
//   Future getPosition( ) async {
//     print ("excuting getPoition");
//     bool service ; 
    
//     service = await Geolocator.isLocationServiceEnabled(); 
//     print (service ); 
    
   

//     LocationPermission per = LocationPermission.denied ; 
//     if ( per == LocationPermission.denied){
//         per = await Geolocator.requestPermission();
       

//      if (service == true ){
//       per = await Geolocator.checkPermission(); 
//        print ( " permission is ");
//         print (per);

//     }

//       if (per == LocationPermission.always){ // not .always 
//       await getLatAndLong();
      
//     }
//       }

   
//   }

//   Future<Position> getLatAndLong() async{

//     print ("excuting LatandLng");
    
//      cl =  await Geolocator.getCurrentPosition().then((value) => value );

//      print(cl.latitude);
//      print(cl.longitude);

//       sourcelocation  = LatLng( cl.latitude , cl.longitude);
     
//      currentLocation = LatLng( cl.latitude , cl.longitude);

     

//     return cl ; 

    
    
  
//   }
  
   

//   //  @override
//   // void initState()
//   // {
//   //   getPosition();
//   //   initState(); 
//   // }

// class EmergencyTrackingPage extends StatefulWidget {
//   const EmergencyTrackingPage({Key? key}) : super(key: key);

//   @override
//   State<EmergencyTrackingPage> createState() => EmergencyTrackingPageState();
// }

// class EmergencyTrackingPageState extends State<EmergencyTrackingPage> {
//   final Completer<GoogleMapController> _controller = Completer();

 

   
//    List<LatLng> polylineCoordinates = [];
   
//    // getting our own location 
//   //  LocationData? currentLocation ; 

//   //  void getCurrentLocation () async {
//   //   Location location = Location ();
//   //   location.getLocation().then((
//   //     location)
//   //     {
//   //     currentLocation = location ; 
//   //   },
//   //   );

//   //   GoogleMapController googleMapController = await _controller.future; 
    
//   //   //change the current location as the physicallocation changes 
//   //   location.onLocationChanged.listen((newLoc) {
//   //       currentLocation = newLoc ; 

//   //       googleMapController.animateCamera(CameraUpdate.newCameraPosition(
//   //         CameraPosition(
//   //         zoom: 13.5,
//   //         target: LatLng(newLoc.latitude!,
//   //         newLoc.longitude!,
//   //        )
//   //       )
//   //       ),
//   //       );

//   //       setState(() {});
//   //   },);
//   //  } 


//     //put polyline value in the array 
//     void getPolyPoints() async{

//       PolylinePoints polylinePoints = PolylinePoints();

//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(google_api_key,
//        PointLatLng(sourcelocation.latitude, sourcelocation.longitude),
//         PointLatLng(destlocation.latitude,destlocation.longitude),
//         );

//         if(result.points.isNotEmpty){
//           print("polyline points exist ");
//           result.points.forEach(
//           (PointLatLng point) =>
//                     polylineCoordinates.add (
//                       LatLng(point.latitude, point.longitude)
//                       ),
//           );

//           setState ((){});
//         }
//     }
    
//     @override
//     void initState()  { 

//       print ("excuting initState");
      
//       //getCurrentLocation();
//       //getPolyPoints();
//       super.initState();
//       getPosition() ;
      
//     }
//   @override
//   Widget build(BuildContext context) {
//     print ("excuting the build");
//     setState ((){});
    
     
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Emergency Location",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: //currentLocation == null 
//       //? const Center (child: Text ("Loading"))
//       /*:*/ GoogleMap(
//           initialCameraPosition: CameraPosition(
//           target: LatLng(currentLocation!.latitude! , currentLocation!.longitude!),
//           zoom: 14.5
//           ),
//           polylines: {
//             Polyline(
//               polylineId: PolylineId("route"),
//               points: polylineCoordinates,
//               color: primaryColor,
//               width: 6 
//               ),

//           },
//           markers: {

//             Marker(
//               markerId:const MarkerId("currentLocation"),
//               position: LatLng(
//                 currentLocation!.latitude!, 
//                 currentLocation!.longitude!) ,
//               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

              
//                ),

//              Marker(
//               markerId:MarkerId("source"),
//               position: sourcelocation,
//                ),

//             const Marker(
//               markerId:MarkerId("dest"),
//               position: destlocation,
//                 ),
//           },

//           onMapCreated: (mapController)
//           {
//             _controller.complete(mapController);
//           },
//           ),

          
//       );
    
        
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:emergencies/constants.dart';
import 'package:geolocator/geolocator.dart';

class EmergencyTrackingPage extends StatefulWidget {
  const EmergencyTrackingPage({Key? key}) : super(key: key);

  @override
  State<EmergencyTrackingPage> createState() => EmergencyTrackingPageState();
}

class EmergencyTrackingPageState extends State<EmergencyTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng sourceLocation = const LatLng(0, 0);
  final LatLng destLocation = const LatLng(30.0444, 31.2357);
  LatLng currentLocation = const LatLng(0, 0);

  List<LatLng> polylineCoordinates = [];

  

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
      }
    }
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destLocation.latitude, destLocation.longitude),
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
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    print("Executing build");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emergency Location",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: currentLocation.latitude == 0 && currentLocation.longitude == 0
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
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
                // Marker(
                //   markerId: const MarkerId("currentLocation"),
                //   position: currentLocation,
                //   icon: BitmapDescriptor.defaultMarkerWithHue(
                //     BitmapDescriptor.hueBlue,
                //   ),
                // ),
                Marker(
                markerId: MarkerId("currentLocation"),
                position: currentLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
              ),

                Marker(
                  markerId: const MarkerId("source"),
                  position: sourceLocation,
                ),
                Marker(
                  markerId: const MarkerId("dest"),
                  position: destLocation,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}