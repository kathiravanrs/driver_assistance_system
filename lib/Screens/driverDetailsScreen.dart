import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Widgets/driverCard.dart';

class DriverPage extends StatefulWidget {
  DriverPage({Key key}) : super(key: key);

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final dbRef = FirebaseDatabase.instance.reference().child("Drivers");

  final headingStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  final dataStyle = TextStyle(
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Details Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                List<dynamic> values = snapshot.data.value;
                values = values.sublist(1);
                print(values);
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: values.length,
                    itemBuilder: (BuildContext context, int index) {
                      var name = values[index]["Name"];
                      var number = values[index]["Vehicle"];
                      var rash = values[index]["Rash"].toString();
                      return DriverCard(
                        driverName: name,
                        vehNumber: number,
                        rashCount: rash,
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
