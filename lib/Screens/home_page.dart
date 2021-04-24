import 'package:flutter/material.dart';
import 'package:driver_assistance_system/auth.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }

    }

    return new Scaffold(
      appBar: new AppBar(
        title: Text('Driver Assistance System - Test'),
        actions: <Widget>[
          new TextButton(
              onPressed: _signOut,
              child: new Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white))
          )
        ],
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