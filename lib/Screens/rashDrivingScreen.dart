import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:driver_assistance_system/Widgets/RashLog.dart';
class RashDrivingPage extends StatefulWidget {
  RashDrivingPage({Key key}) : super(key: key);

  @override
  _RashDrivingPageState createState() => _RashDrivingPageState();
}

class _RashDrivingPageState extends State<RashDrivingPage> {
  final dbRef = FirebaseDatabase.instance.reference().child("RashDriving");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rash Driving Log'),
      ),
      body: FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            List<dynamic> values = snapshot.data.value;
            values = values.sublist(1);

            return new ListView.builder(
                shrinkWrap: true,
                itemCount: values.length,
                itemBuilder: (BuildContext context, int index) {
                  var name = values[index]["Name"];
                  var time = values[index]["Time"];
                  return RashLog(name: name, time: time);
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
