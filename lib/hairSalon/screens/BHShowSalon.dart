import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import 'load_widget.dart';

class BHShowSalon extends StatefulWidget {
  const BHShowSalon({Key? key}) : super(key: key);

  @override
  State<BHShowSalon> createState() => _BHShowSalonState();
}

class _BHShowSalonState extends State<BHShowSalon> {

  Position? current;

  Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _markers = [];

   List _latLen = [];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future getInfo()async{
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      current = position;
    }).catchError((e) {
      debugPrint(e);
    });
    return current;
  }

  loadData() async{
    await FirebaseFirestore.instance.collection("owners").get().then((value){
        value.docs.forEach((element) {
            _latLen.add({"coord":LatLng(element["latitude"], element["longitude"]),"name":element["salon_name"]});
        });
    });
    setState(() {
  print(_latLen);
    });

    for(int i=0 ;i<_latLen.length; i++){
      _markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            icon: BitmapDescriptor.defaultMarker,
            position: _latLen[i]["coord"],
            infoWindow: InfoWindow(
              title: _latLen[i]["name"],
            ),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Choose Shops"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future:getInfo(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return BHLoading();
          }
          return Container(
            child: SafeArea(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(current!.latitude, current!.longitude),
                  zoom: 11,
                ),
                markers: Set<Marker>.of(_markers),
                mapType: MapType.normal,
                myLocationEnabled: true,
                circles: {
                  Circle( circleId: CircleId('currentCircle'),
                    center: LatLng(current!.latitude,current!.longitude),
                    radius: 10000,
                    fillColor: Colors.blue.shade200.withOpacity(0.5),
                    strokeColor:  Colors.blue.shade200.withOpacity(0.1),
                  ),
                },
                myLocationButtonEnabled: true,
                compassEnabled: true,
                onMapCreated: (GoogleMapController controller){
                  _controller.complete(controller);
                },
              ),
            ),
          );
        }
      ),
    );
  }
}