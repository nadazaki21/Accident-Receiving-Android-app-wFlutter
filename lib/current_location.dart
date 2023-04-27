//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location ({Key? key}) : super(key: key);


  
  @override
  CurrentLocation createState()  =>  CurrentLocation();


  }

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
    return cl =  await Geolocator.getCurrentPosition().then((value) => value );
    
    
  
  }
  

  @override
  void initState()
  {
    getPosition();
    initState(); 
  }

class CurrentLocation extends State<Location> {
  
  
  @override


  Widget build(BuildContext context) {

    return Scaffold(

    body: BackButton (onPressed: () async {
      cl = await getLatAndLong(); 
      print(cl.latitude);
      print(cl.longitude);

    })
     
        );
  }

}
