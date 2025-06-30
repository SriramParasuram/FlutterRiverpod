import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;

class LocationService {
  final loc.Location _location = loc.Location();

  LocationService() {
    _location.changeSettings(
      accuracy: loc.LocationAccuracy.high,
      interval: 1000, // in ms
      distanceFilter: 1, // in meters
    );
    _location.enableBackgroundMode();
  }

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    loc.PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<loc.LocationData> getLocation() async {
    return await _location.getLocation();
  }

  Stream<loc.LocationData> getLocationStream() {
    return _location.onLocationChanged.map((data) {
      print('📍 New location: ${data.latitude}, ${data.longitude}');
      return data;
    });
  }

}
