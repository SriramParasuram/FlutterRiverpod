import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/location/location_notifier.dart';

class LocationScreen extends HookConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationControllerProvider);
    final controller = ref.read(locationControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("📍 Location Tracker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: controller.toggleTracking,
              child: Text(locationState.isTracking
                  ? "🛑 Stop Tracking"
                  : "▶️ Start Tracking"),
            ),
            const SizedBox(height: 20),
            locationState.isTracking && locationState.currentLocation != null
                ? Text(
              "Live → Lat: ${locationState.currentLocation?.latitude}, Lng: ${locationState.currentLocation?.longitude}",
              style: const TextStyle(fontSize: 18),
            )
                : const Text("Tracking is OFF"),
          ],
        ),
      ),
    );
  }
}