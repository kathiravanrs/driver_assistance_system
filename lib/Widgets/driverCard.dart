import 'package:flutter/material.dart';

class DriverCard extends StatefulWidget {
  final String driverName;
  final String vehNumber;
  final String rashCount;
  final String state;

  DriverCard({this.driverName, this.vehNumber, this.rashCount, this.state});

  @override
  _DriverCardState createState() => _DriverCardState();
}

class _DriverCardState extends State<DriverCard> {
  final headingStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  final dataStyle = TextStyle(
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Card(
          elevation: 10,
          child: Row(
            children: [
              if (widget.state == "Awake")
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0,15.0,0,10),
                        child: Icon(
                          Icons.electric_car_rounded,
                          size: 120,
                        ),
                      ),

                      Text("Awake",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              if (widget.state == "Drowsy")
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0,15.0,0,10),
                        child: Icon(
                          Icons.bedtime,
                          size: 120,
                        ),
                      ),
                      Text("Drowsy",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Driver Name',
                      style: headingStyle,
                    ),
                    Text(
                      widget.driverName.toString(),
                      style: dataStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Vehicle Number', style: headingStyle),
                    Text(
                      widget.vehNumber.toString(),
                      style: dataStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Rash Driving Incidents', style: headingStyle),
                    Text(
                      widget.rashCount.toString(),
                      style: dataStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
