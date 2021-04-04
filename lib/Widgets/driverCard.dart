import 'package:flutter/material.dart';

class DriverCard extends StatefulWidget {
  final String driverName;
  final String vehNumber;
  final String rashCount;

  DriverCard({this.driverName, this.vehNumber, this.rashCount});

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
              Icon(
                Icons.perm_contact_cal_rounded,
                size: 120,
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
