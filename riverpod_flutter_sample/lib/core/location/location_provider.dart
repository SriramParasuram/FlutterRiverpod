import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart' as loc;

import 'location_service.dart';

// Provides the LocationService instance
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Requests location permission
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return await service.requestLocationPermission();
});

// Streams continuous location updates
final locationStreamProvider = StreamProvider<loc.LocationData>((ref) {
  final service = ref.watch(locationServiceProvider);
  return service.getLocationStream(); // Custom stream method from service
});

// Gets the initial one-time location
final initialLocationProvider = FutureProvider<loc.LocationData>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return await service.getLocation();
});