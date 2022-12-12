import 'package:flutter/material.dart';
import 'package:location_manager/location_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    LocationManager newLocationManager = LocationManager();
    startService() {
      newLocationManager.getLocation(
        onLocationValue: (val) {
          print("Current Location: $val");
        },
        isLocationTrack: true,
        onRejectPermission: () {
          print("You need to give location permission");
        },
      );
    }

    stopService() {
      newLocationManager.stopService();
    }

    resumeService() {
      newLocationManager.resumeService();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Location Manager',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Location Manager'),
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  ),
                  onPressed: () {
                    startService();
                  },
                  child: Text("Start"),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  ),
                  onPressed: () {
                    stopService();
                  },
                  child: Text("Stop"),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  ),
                  onPressed: () {
                    resumeService();
                  },
                  child: Text("Resume"),
                ),
              ],
            ),
          )),
    );
  }
}
