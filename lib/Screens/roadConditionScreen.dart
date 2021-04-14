import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum Road { good, bad }

class RoadConditionPage extends StatefulWidget {
  RoadConditionPage({Key key}) : super(key: key);

  @override
  _RoadConditionPageState createState() => _RoadConditionPageState();
}

class _RoadConditionPageState extends State<RoadConditionPage> {
  final dbRef = FirebaseDatabase.instance.reference().child("RoadCondition");
  final dbRefLoc = FirebaseDatabase.instance.reference().child("LastPosition");

  Position _currentPosition;
  String _currentAddress;
  Timer timer;
  final Set<Polyline> polyline = {};
  final Set<Marker> marker = {};

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(13.048891, 80.161575);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  // _getCurrentLocation() async{
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   // dbRefLoc.push().set({"Position":LatLng(position.latitude,position.longitude).toString()});
  //   setState(() {
  //       marker.add(Marker(markerId: MarkerId('jg'),position: LatLng(position.latitude,position.longitude)));
  //       _currentPosition = position;
  //     });
  // }



  addToPolyline(List<dynamic> seg, Road type) {
    seg = seg.sublist(1);
    seg.forEach((element) {
      polyline.add(
        Polyline(
          polylineId: PolylineId('line2'),
          visible: true,
          points: [
            LatLng(element["StartLat"], element["StartLng"]),
            LatLng(element["StopLat"], element["StopLng"])
          ],
          width: 6,
          color: type == Road.good ? Colors.green : Colors.red,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _getCurrentLocation());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Road Condition'),
        ),
        body: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                List<dynamic> goodSeg = (snapshot.data.value["GoodSegments"]);
                print(goodSeg);

                Map<dynamic, dynamic> badSeg = (snapshot.data.value["BadSegments"]);
                print(badSeg.values);
                addToPolyline(goodSeg, Road.good);
                addToPolyline(badSeg.values.toList(), Road.bad);

                return Stack(
                  children: <Widget>[
                    GoogleMap(
                      polylines: polyline,
                      markers: marker,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: _center, zoom: 18.6, bearing: 90.0, tilt: 30),
                    ),
                    if (_currentPosition != null && _currentAddress != null)
                      Text(_currentAddress),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            })

        );
  }
}
