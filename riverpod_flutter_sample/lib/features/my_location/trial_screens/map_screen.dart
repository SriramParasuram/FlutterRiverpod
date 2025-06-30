import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_notifier.dart';
// Update path as per your file structure

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationControllerProvider);
    final controller = ref.read(locationControllerProvider.notifier);

    final location = locationState.currentLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('Live Location')),
      body: location != null
          ? FlutterMap(
              // options: MapOptions(
              //   center: LatLng(location.latitude!, location.longitude!),
              //   zoom: 16,
              //   maxZoom: 18,
              //   userAgentPackageName:
              //       'com.sriram', // Update to real bundle ID
              // ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.sriram',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(location.latitude!, location.longitude!),
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.toggleTracking(),
        child: Icon(locationState.isTracking ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
