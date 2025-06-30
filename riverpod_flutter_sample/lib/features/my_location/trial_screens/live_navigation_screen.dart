import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart' as latlong2;

import 'package:uuid/uuid.dart';

import '../../../core/location/location_notifier.dart';


class LiveTrackingMapScreen extends ConsumerStatefulWidget {
  const LiveTrackingMapScreen({super.key});

  @override
  ConsumerState<LiveTrackingMapScreen> createState() => _LiveTrackingMapScreenState();
}

class _LiveTrackingMapScreenState extends ConsumerState<LiveTrackingMapScreen> {
  static const String googleApiKey = 'AIzaSyCgEM67317BMVfo-r82iyVfjXP4kSv8niY';
  late GoogleMapController _mapController;
  LatLng? _currentLatLng;
  LatLng? _destination;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    ref.read(locationControllerProvider.notifier).toggleTracking();
  }

  void _updateRoute(LatLng start, LatLng end) async {
    // final result = await PolylinePoints().getRouteBetweenCoordinates(
    //   "YOUR_GOOGLE_MAPS_API_KEY",
    //   PointLatLng(start.latitude, start.longitude),
    //   PointLatLng(end.latitude, end.longitude),
    // );

    final result = await PolylinePoints().getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(start.latitude, start.longitude),
        destination: PointLatLng(end.latitude, end.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: googleApiKey,
    );

    if (result.points.isNotEmpty) {
      final points = result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            points: points,
            color: Colors.blue,
            width: 4,
          )
        };
      });
    }
  }

  void _onDestinationSelected(LatLng dest) {
    final start = _currentLatLng;
    if (start != null) {
      _updateRoute(start, dest);
    }
    setState(() => _destination = dest);
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationControllerProvider).currentLocation;

    if (location != null) {
      _currentLatLng = LatLng(location.latitude!, location.longitude!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Live Tracking Map")),
      body: Stack(
        children: [
          if (_currentLatLng != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _currentLatLng!, zoom: 15),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) => _mapController = controller,
              polylines: _polylines,
              markers: {
                if (_destination != null)
                  Marker(markerId: const MarkerId("dest"), position: _destination!),
              },
            ),
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: TextField(
              onSubmitted: (value) async {
                // You can use Google Places API to convert search string to LatLng
                // For now, dummy hardcoded
                _onDestinationSelected(LatLng(12.9346, 77.6266));
              },
              decoration: const InputDecoration(
                hintText: "Enter destination",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ref.read(locationControllerProvider.notifier).stopTracking();
    super.dispose();
  }
}