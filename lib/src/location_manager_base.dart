import 'dart:async';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:location_permissions/location_permissions.dart' as location_perm;

class LocationManager {
  LatLng currentLocation;
  Location location = Location();
  Function(LatLng) onLocationValue;
  VoidCallback onRejectPermission;
  bool isLocationTrack;

  StreamSubscription<LocationData> locationManager;

  Future<void> getLocation({Function(LatLng) onLocationValue, VoidCallback onRejectPermission, bool isLocationTrack = false, int interval = 1000}) async {
    if (await getPermissionStatus()) {
      var serviceStatus = await location_perm.LocationPermissions().checkServiceStatus();

      if (serviceStatus != location_perm.ServiceStatus.enabled) {
        await location_perm.LocationPermissions().serviceStatus.listen((event) {
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

  Future<void> getCurrentLocation({Function(LatLng) onLocationValue}) async {
    var _locationResult = await location.getLocation();
    onLocationValue(LatLng(_locationResult.latitude, _locationResult.longitude));
  }

  Future<void> listenLocation({Function(LatLng) onLocationValue, int interval}) async {
    await location.changeSettings(interval: interval);
    locationManager = await location.onLocationChanged.listen((LocationData currentLocation) {
      print('listening...');
    });

    locationManager.onData((data) {
      try {
        onLocationValue(LatLng(data.latitude, data.longitude));
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
    if (locationManager != null) {
      locationManager.pause();
      print('Stoped');
    }
  }

  Future<void> resumeService() async {
    if (locationManager != null) {
      locationManager.resume();
      print('Resuming...');
    }
  }
}
