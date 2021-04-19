import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';

import 'Screens/homescreen.dart';
import 'Screens/driverDetailsScreen.dart';
import 'Screens/rashDrivingScreen.dart';
import 'Screens/roadConditionScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

enum Road { good, bad }

class _MyAppState extends State<MyApp> {
  Timer timer;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final dbRef = FirebaseDatabase.instance.reference();

  _getCurrentLocation() async {
    Position secondLastPosition;
    Road condition;

    await dbRef
        .child('LastPosition/Kathiravan/Last')
        .once()
        .then((DataSnapshot snapshot) {
      var data = json.decode(snapshot.value['Position']);
      print(data[0]);
      secondLastPosition = Position(latitude: data[0], longitude: data[1]);
      print(secondLastPosition);
    });

    await dbRef.child('CurrentRoad').once().then((DataSnapshot snapshot) {
      if (snapshot.value['Condition'].toString() == 'Bad') {
        condition = Road.bad;
      } else if (snapshot.value['Condition'].toString() == 'Good') {
        condition = Road.good;
      }
    });

    Position lastPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    dbRef.child('LastPosition/Kathiravan/Last').set({
      "Position": [lastPosition.latitude, lastPosition.longitude].toString(),
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    dbRef.child('LastPosition/Kathiravan/SecondLast').set({
      "Position": [secondLastPosition.latitude, secondLastPosition.longitude]
          .toString(),
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    if (condition == Road.good) {
      dbRef.child('RoadCondition/GoodSegments').push().set({
        'StartLat': lastPosition.latitude,
        "StartLng": lastPosition.longitude,
        "StopLat": secondLastPosition.latitude,
        "StopLng": secondLastPosition.longitude
      });
      print('Good Road');
    } else if (condition == Road.bad) {
      dbRef.child('RoadCondition/BadSegments').push().set({
        'StartLat': lastPosition.latitude,
        "StartLng": lastPosition.longitude,
        "StopLat": secondLastPosition.latitude,
        "StopLng": secondLastPosition.longitude
      });
      print('Bad Road');
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) => _getCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error',
              textDirection: TextDirection.ltr,
            ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseMessaging messaging = FirebaseMessaging.instance;
            // final databaseReference = FirebaseDatabase.instance.reference();
            messaging.subscribeToTopic('pushNotifications');

            FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              print('Got a message whilst in the foreground!');
              print('Message data: ${message.data}');

              if (message.notification != null) {
                print(
                    'Message also contained a notification: ${message.notification}');
              }
            });

            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Driver Assistance Systems',
                theme: ThemeData(
                  primarySwatch: Colors.deepPurple,
                ),
                routes: <String, WidgetBuilder>{
                  '/driver': (BuildContext context) => new DriverPage(),
                  '/rash': (BuildContext context) => new RashDrivingPage(),
                  '/road': (BuildContext context) => new RoadConditionPage(),
                  '/': (BuildContext context) => new MyHomePage(),
                });
          }
          return Center(
              child: Text(
            'Loading',
            textDirection: TextDirection.ltr,
          ));
        });
  }
}
