// location_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart' as loc;
import 'location_provider.dart';
import 'location_service.dart';

class LocationState {
  final loc.LocationData? currentLocation;
  final bool isTracking;

  LocationState({this.currentLocation, this.isTracking = false});

  LocationState copyWith({
    loc.LocationData? currentLocation,
    bool? isTracking,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}

class LocationController extends StateNotifier<LocationState> {
  final LocationService _locationService;
  late final Stream<loc.LocationData> _stream;

  LocationController(this._locationService) : super(LocationState()) {
    _stream = _locationService.getLocationStream();
  }

  void toggleTracking() {
    final tracking = !state.isTracking;
    print("toggle tracking called!! $tracking");
    state = state.copyWith(isTracking: tracking);
    if (tracking) {
      _stream.listen((locationData) {
        print(
            "location data is ${locationData.latitude} and long is ${locationData.longitude} ");
        state = state.copyWith(currentLocation: locationData);
      });
    }
  }

  Future<void> getInitialLocation() async {
    final location = await _locationService.getLocation();
    state = state.copyWith(currentLocation: location);
  }

  void stopTracking() {
    state = state.copyWith(isTracking: false);
  }
}

final locationControllerProvider =
    StateNotifierProvider<LocationController, LocationState>((ref) {
  final service = ref.watch(locationServiceProvider);
  return LocationController(service);
});
