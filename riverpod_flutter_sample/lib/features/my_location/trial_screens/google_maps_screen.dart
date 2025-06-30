import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/location/location_notifier.dart';

class UberMapScreen extends ConsumerStatefulWidget {
  const UberMapScreen({super.key});

  @override
  ConsumerState<UberMapScreen> createState() => _UberMapScreenState();
}

class _UberMapScreenState extends ConsumerState<UberMapScreen> {
  static const String googleApiKey = 'AIzaSyCgEM67317BMVfo-r82iyVfjXP4kSv8niY';
  late GoogleMapController _mapController;

  LatLng? currentLocation;
  LatLng? destination;
  LatLng? customFromLocation;

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationControllerProvider.notifier).getInitialLocation();
      ref.read(locationControllerProvider.notifier).toggleTracking();
    });
  }

  @override
  void dispose() {
    ref.read(locationControllerProvider.notifier).stopTracking();
    super.dispose();
  }

  void _updatePolyline(LatLng from, LatLng to) async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(from.latitude, from.longitude),
        destination: PointLatLng(to.latitude, to.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: googleApiKey,
    );

    if (result.points.isNotEmpty) {
      final List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            width: 6,
            color: Colors.blue,
          )
        };

        _markers = {
          Marker(markerId: const MarkerId('from'), position: from),
          Marker(markerId: const MarkerId('to'), position: to),
        };
      });

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          from.latitude < to.latitude ? from.latitude : to.latitude,
          from.longitude < to.longitude ? from.longitude : to.longitude,
        ),
        northeast: LatLng(
          from.latitude > to.latitude ? from.latitude : to.latitude,
          from.longitude > to.longitude ? from.longitude : to.longitude,
        ),
      );

      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  void _selectToLocation() {
    const toLocation = LatLng(13.0358, 80.2456); // Your home location
    setState(() {
      destination = toLocation;
    });

    final from = customFromLocation ?? currentLocation;
    if (from != null) {
      _updatePolyline(from, toLocation);
    }
  }

  void _selectFromLocation() {
    setState(() {
      customFromLocation = const LatLng(13.0214, 80.2192); // Custom from location
    });

    if (destination != null) {
      _updatePolyline(customFromLocation!, destination!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Proper ref.listen in build method
    ref.listen<LocationState>(locationControllerProvider, (prev, next) {
      if (next.currentLocation != null) {
        setState(() {
          currentLocation = LatLng(
            next.currentLocation!.latitude!,
            next.currentLocation!.longitude!,
          );
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Uber Style Map")),
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: currentLocation!,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _selectToLocation,
                  child: const Text("Set Destination"),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _selectFromLocation,
                  child: const Text("Set Custom From Location"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}