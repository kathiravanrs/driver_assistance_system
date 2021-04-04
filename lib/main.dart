import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Screens/homescreen.dart';
import 'Screens/driverDetailsScreen.dart';
import 'Screens/rashDrivingScreen.dart';
import 'Screens/roadConditionScreen.dart';

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
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