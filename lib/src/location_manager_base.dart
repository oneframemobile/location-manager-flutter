import 'dart:async';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:location_permissions/location_permissions.dart' as location_perm;

class LocationManager {
  late LatLng currentLocation;
  Location location = Location();
  late Function(LatLng) onLocationValue;
  late VoidCallback onRejectPermission;
  late bool isLocationTrack;

  late StreamSubscription<LocationData> locationManager;

  Future<void> getLocation({required Function(LatLng) onLocationValue, required VoidCallback onRejectPermission, bool isLocationTrack = false, int interval = 1000}) async {
    if (await getPermissionStatus()) {
      var serviceStatus = await location_perm.LocationPermissions().checkServiceStatus();

      if (serviceStatus != location_perm.ServiceStatus.enabled) {
        location_perm.LocationPermissions().serviceStatus.listen((event) {
          if (event.index == 2) {
            getLocation(onLocationValue: onLocationValue, isLocationTrack: isLocationTrack, onRejectPermission: onRejectPermission);
          } else {
            location.requestService();
          }
        });
      } else {
        if (isLocationTrack) {
          await listenLocation(onLocationValue: onLocationValue, interval: interval);
        } else {
          await getCurrentLocation(onLocationValue: onLocationValue);
        }
      }
    } else {
      onRejectPermission();
    }
  }

  Future<void> getCurrentLocation({required Function(LatLng) onLocationValue}) async {
    var _locationResult = await location.getLocation();
    onLocationValue(LatLng(_locationResult.latitude!, _locationResult.longitude!));
  }

  Future<void> listenLocation({required Function(LatLng) onLocationValue, int interval = 3000}) async {
    await location.changeSettings(interval: interval);
    locationManager = location.onLocationChanged.listen((LocationData currentLocation) {
      print('listening...');
    });

    locationManager.onData((data) {
      try {
        onLocationValue(LatLng(data.latitude!, data.longitude!));
      } catch (e) {
        print("listenLocation catch");
      }
    });
  }

  Future<bool> getPermissionStatus() async {
    var status = await location.hasPermission();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return await requestPermission();
    }
  }

  Future<bool> requestPermission() async {
    var status = await handler.Permission.location.request().isGranted;
    if (status) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> stopService() async {
    try {
      locationManager.pause();
      print('Stoped');
    } catch (e) {
      print('error...');
    }
  }

  Future<void> resumeService() async {
    try {
      locationManager.resume();
      print('Resuming...');
    } catch (e) {
      print('error...');
    }
  }
}
