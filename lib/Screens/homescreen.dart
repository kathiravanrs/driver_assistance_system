import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Assistance System - Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/driver');
                },
                child: Text(
                  'Driver Details',
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/rash');
                },
                child: Text(
                  'Rash Driving Log',
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/road');
                  },
                child: Text(
                  'Road Condition',
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
