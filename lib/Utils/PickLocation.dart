import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/Utils/Address.dart';
import 'package:food_donation/Utils/Constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Utils.dart';

class PickLocation extends StatefulWidget {

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  GoogleMapController? _controller;
  Set<Marker> _markers={};
  Position? currentPosition;
  String? currentAddress;
  double longitude= 0.0,latitude=0.0;
  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentLocation();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        centerTitle: true,
        title: Text("Pick Your Location", style: TextStyle(
            color: Color6,
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),),
        actions: [
          IconButton(
            icon: Icon(Icons.done, size: 25,color: Color6,),
            onPressed: (){
             Address address = Address(address: currentAddress!=null?currentAddress:"Enter Address",latitude: latitude!=null?latitude:currentPosition!.latitude,longitude: longitude!=null?longitude:currentPosition!.longitude);
              Navigator.pop(context,address);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(target: LatLng(32.571144,74.075005)),
            mapType: MapType.normal,
            markers: _markers,
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (tappedLocation){
              _handleTap(tappedLocation);
            },
            onMapCreated: (GoogleMapController controller){
              _controller = controller;
            },
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(right: 70.0, bottom: 30.0, left: 70),
                child: Flushbar(
                  //backgroundColor: Colors.white24,
                  title: currentAddress!=null?currentAddress:"Address couldn't Fetch",
                  duration:  Duration(seconds: 3),
                  message: "Latitude: "+latitude.toString()+",Longitude "+longitude.toString(),
                ),
              ),
            ),
          ),
        ],

      ),
    );
  }

   getCurrentLocation()async{
     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if(!serviceEnabled){
       Utils.showError(context,"Please Enable Location Services");
       return;
     }
     Geolocator.checkPermission().then((permission){
       if(permission == LocationPermission.denied){
         Geolocator.requestPermission().then((permission){
           if(permission!= LocationPermission.denied){
             Geolocator.getCurrentPosition().then((position){
               log(position.toString());
               _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                 target: LatLng(position.latitude,position.longitude),
                 zoom: 18.0,
               )));
               setState(() {
                 currentPosition=position;
                 latitude=position.latitude;
                 longitude=position.longitude;
                 _markers.add(Marker(markerId: MarkerId('Home'),
                     position: LatLng(position.latitude, position.longitude)
                 ));
                 _getAddress();
               });
             });
           }
         });
         return;
       }else if(permission == LocationPermission.deniedForever){
         Utils.showError(context,"You have to give location permission from setting of your device");
         return;
       }
       Geolocator.getCurrentPosition().then((position){

         log(position.toString());
         _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
           target: LatLng(position.latitude,position.longitude),
           zoom: 20.0,
         )));
         setState(() {
           currentPosition=position;
           latitude=position.latitude;
           longitude=position.longitude;
           _markers.add(Marker(
             markerId: MarkerId('Home'),
               position: LatLng(position.latitude, position.longitude),
           ));
           _getAddress();
         });
       });
     });


  }

  _handleTap(LatLng tappedPoint){
    setState(() {
      log("Tapped Poisnt "+tappedPoint.toString());
      latitude=tappedPoint.latitude;
      longitude=tappedPoint.longitude;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
      _getAddress();
    });
  }

  _getAddress() async {
    try {

      List<Placemark> p = await placemarkFromCoordinates(
          latitude!=null?latitude: currentPosition!.latitude, longitude!=null?longitude:currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        currentAddress =
        "${place.name},${place.subLocality}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
