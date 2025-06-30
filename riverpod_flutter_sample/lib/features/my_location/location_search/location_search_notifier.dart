import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../places_model/places_model.dart';
import '../places_provider/places_provider.dart';
import '../places_services/places_service.dart';
import 'dart:math';

class LocationSearchState {
  final PlaceAutocompleteResult? fromPlace;
  final PlaceAutocompleteResult? toPlace;
  final LatLng? fromCoordinates;
  final LatLng? toCoordinates;
  final List<LatLng> polylinePoints;
  final List<PlaceAutocompleteResult> fromSuggestions;
  final List<PlaceAutocompleteResult> toSuggestions;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final LatLngBounds? routeBounds;

  LocationSearchState({
    this.fromPlace,
    this.toPlace,
    this.fromCoordinates,
    this.toCoordinates,
    this.polylinePoints = const [],
    this.fromSuggestions = const [],
    this.toSuggestions = const [],
    this.markers = const {},
    this.polylines = const {},
    this.routeBounds,
  });

  LocationSearchState copyWith({
    PlaceAutocompleteResult? fromPlace,
    PlaceAutocompleteResult? toPlace,
    LatLng? fromCoordinates,
    LatLng? toCoordinates,
    List<LatLng>? polylinePoints,
    List<PlaceAutocompleteResult>? fromSuggestions,
    List<PlaceAutocompleteResult>? toSuggestions,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    LatLngBounds? routeBounds,
  }) {
    return LocationSearchState(
      fromPlace: fromPlace ?? this.fromPlace,
      toPlace: toPlace ?? this.toPlace,
      fromCoordinates: fromCoordinates ?? this.fromCoordinates,
      toCoordinates: toCoordinates ?? this.toCoordinates,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      fromSuggestions: fromSuggestions ?? this.fromSuggestions,
      toSuggestions: toSuggestions ?? this.toSuggestions,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      routeBounds: routeBounds ?? this.routeBounds,
    );
  }
}

class LocationSearchNotifier extends StateNotifier<LocationSearchState> {
  final PlacesService _placesService;

  LocationSearchNotifier(this._placesService) : super(LocationSearchState());


  Duration? eta;

  void updateCurrentLocation(LatLng currentLatLng) async {
    if (state.toCoordinates != null) {
      final routes = await _placesService.getPolylinePoints(
        fromLat: currentLatLng.latitude.toString(),
        fromLng: currentLatLng.longitude.toString(),
        toLat: state.toCoordinates!.latitude.toString(),
        toLng: state.toCoordinates!.longitude.toString(),
      );

      final encodedPoints = routes.first['overview_polyline']['points'];
      final decoded = _decodePolyline(encodedPoints);

      final durationSeconds = routes.first['legs'][0]['duration']['value'];
      eta = Duration(seconds: durationSeconds);

      final livePolyline = Polyline(
        polylineId: const PolylineId('live_route'),
        color: Colors.green,
        width: 5,
        points: decoded,
      );

      final updatedBounds = _calculateLatLngBounds(currentLatLng, state.toCoordinates!);

      state = state.copyWith(
        fromCoordinates: currentLatLng,
        polylinePoints: decoded,
        polylines: {livePolyline},
        routeBounds: updatedBounds,
      );
    }
  }

  Future<void> onSearchChanged(String query, bool isFromField) async {
    if (query.isEmpty) {
      state = state.copyWith(
        fromSuggestions: isFromField ? [] : state.fromSuggestions,
        toSuggestions: isFromField ? state.toSuggestions : [],
      );
      return;
    }

    final suggestions = await _placesService.getAutocomplete(query);

    state = state.copyWith(
      fromSuggestions: isFromField ? suggestions : state.fromSuggestions,
      toSuggestions: isFromField ? state.toSuggestions : suggestions,
    );
  }

  Future<void> setFromPlace(PlaceAutocompleteResult place) async {
    final details = await _placesService.getPlaceDetails(place.placeId);
    final latLng = LatLng(details.lat, details.lng);

    final fromMarker = Marker(
      markerId: const MarkerId('from'),
      position: latLng,
      infoWindow: const InfoWindow(title: "From"),
    );

    state = state.copyWith(
      fromPlace: place,
      fromCoordinates: latLng,
      fromSuggestions: [],
      markers: {...state.markers.where((m) => m.markerId.value != 'from'), fromMarker},
    );

    maybeFetchPolyline();
  }



  Future<void> setToPlace(PlaceAutocompleteResult place) async {
    final details = await _placesService.getPlaceDetails(place.placeId);
    final latLng = LatLng(details.lat, details.lng);

    final toMarker = Marker(
      markerId: const MarkerId('to'),
      position: latLng,
      infoWindow: const InfoWindow(title: "To"),
    );

    state = state.copyWith(
      toPlace: place,
      toCoordinates: latLng,
      toSuggestions: [],
      markers: {...state.markers.where((m) => m.markerId.value != 'to'), toMarker},
    );

    maybeFetchPolyline();
  }

  Future<void> maybeFetchPolyline() async {
    final from = state.fromCoordinates;
    final to = state.toCoordinates;

    if (from != null && to != null) {
      final routes = await _placesService.getPolylinePoints(
        fromLat: from.latitude.toString(),
        fromLng: from.longitude.toString(),
        toLat: to.latitude.toString(),
        toLng: to.longitude.toString(),
      );

      final encodedPoints = routes.first['overview_polyline']['points'];
      final decoded = _decodePolyline(encodedPoints);

      final routePolyline = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: decoded,
      );

      // Calculate bounds
      final bounds = _calculateLatLngBounds(from, to);

      state = state.copyWith(
        polylinePoints: decoded,
        polylines: {routePolyline},
        routeBounds: bounds,
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  LatLngBounds _calculateLatLngBounds(LatLng p1, LatLng p2) {
    return LatLngBounds(
      southwest: LatLng(
        min(p1.latitude, p2.latitude),
        min(p1.longitude, p2.longitude),
      ),
      northeast: LatLng(
        max(p1.latitude, p2.latitude),
        max(p1.longitude, p2.longitude),
      ),
    );
  }


  Future<void> setFromLatLng(double lat, double lng, String address) async {
    final latLng = LatLng(lat, lng);

    final fromMarker = Marker(
      markerId: const MarkerId('from'),
      position: latLng,
      infoWindow: const InfoWindow(title: "From"),
    );

    state = state.copyWith(
      fromCoordinates: latLng,
      fromPlace: PlaceAutocompleteResult(description: address, placeId: ''),
      markers: {
        ...state.markers.where((m) => m.markerId.value != 'from'),
        fromMarker,
      },
    );

    maybeFetchPolyline();
  }
}

final locationSearchNotifierProvider =
StateNotifierProvider<LocationSearchNotifier, LocationSearchState>((ref) {
  final placesService = ref.watch(placesServiceProvider);
  return LocationSearchNotifier(placesService);
});