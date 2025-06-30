import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks_riverpod_app/features/my_location/places_model/places_model.dart';
import 'package:flutter_hooks_riverpod_app/features/my_location/places_provider/places_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/location/location_notifier.dart';
import 'location_search/location_search_notifier.dart';

class LocationSearchMapScreen extends ConsumerStatefulWidget {
  const LocationSearchMapScreen({super.key});

  @override
  ConsumerState<LocationSearchMapScreen> createState() =>
      _LocationSearchMapScreenState();
}

class _LocationSearchMapScreenState
    extends ConsumerState<LocationSearchMapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final FocusNode _fromFocus = FocusNode();
  final FocusNode _toFocus = FocusNode();

  Timer? _debounce;
  bool _hasUpdatedFromField = false;
  late final ProviderSubscription<LocationState> _locationListener;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationControllerProvider.notifier).getInitialLocation();
      ref.read(locationControllerProvider.notifier).toggleTracking();

      _locationListener = ref.listenManual<LocationState>(
        locationControllerProvider,
            (prev, next) async {
          if (next.currentLocation != null) {
            final lat = next.currentLocation!.latitude!;
            final lng = next.currentLocation!.longitude!;
            final currentLatLng = LatLng(lat, lng);

            if (!_hasUpdatedFromField) {
              final address = await ref
                  .read(placesServiceProvider)
                  .getAddressFromLatLng(lat: lat, lng: lng);

              if (address != null && mounted) {
                _fromController.text = address;
                await ref
                    .read(locationSearchNotifierProvider.notifier)
                    .setFromLatLng(lat, lng, address);
              }

              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(lat, lng), zoom: 16),
                ),
              );

              _hasUpdatedFromField = true;
            } else {
               ref
                  .read(locationSearchNotifierProvider.notifier)
                  .updateCurrentLocation(currentLatLng);

              final state = ref.read(locationSearchNotifierProvider);
              if (state.routeBounds != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngBounds(state.routeBounds!, 100),
                );
              }
            }
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _locationListener.close();
    _mapController?.dispose();
    _fromController.dispose();
    _toController.dispose();
    _fromFocus.dispose();
    _toFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationSearchNotifierProvider);
    final eta = ref.read(locationSearchNotifierProvider.notifier).eta;

    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(title: const Text('Location Search')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _fromController,
                    focusNode: _fromFocus,
                    decoration: const InputDecoration(labelText: 'From'),
                    onChanged: (value) => _onSearchChanged(value, true),
                  ),
                  if (state.fromSuggestions.isNotEmpty && _fromFocus.hasFocus)
                    _buildSuggestionList(state.fromSuggestions, true),
                  TextField(
                    controller: _toController,
                    focusNode: _toFocus,
                    decoration: const InputDecoration(labelText: 'To'),
                    onChanged: (value) => _onSearchChanged(value, false),
                  ),
                  if (state.toSuggestions.isNotEmpty && _toFocus.hasFocus)
                    _buildSuggestionList(state.toSuggestions, false),
                  if (eta != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Estimated time: ${eta.inMinutes} min"),
                    ),
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(20.5937, 78.9629),
                  zoom: 4,
                ),
                onMapCreated: _onMapCreated,
                markers: state.markers,
                polylines: state.polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onSearchChanged(String query, bool isFromField) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref
          .read(locationSearchNotifierProvider.notifier)
          .onSearchChanged(query, isFromField);
    });
  }

  Future<void> _onSuggestionSelected(
      PlaceAutocompleteResult result, bool isFromField) async {
    _dismissKeyboard();
    final notifier = ref.read(locationSearchNotifierProvider.notifier);

    if (isFromField) {
      _fromController.text = result.description;
      await notifier.setFromPlace(result);
    } else {
      _toController.text = result.description;
      await notifier.setToPlace(result);
    }

    final state = ref.read(locationSearchNotifierProvider);

    if (state.fromPlace != null && state.toPlace != null) {
      await notifier.maybeFetchPolyline();
    }

    if (state.routeBounds != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(state.routeBounds!, 100),
      );
    }
  }

  Widget _buildSuggestionList(
      List<PlaceAutocompleteResult> suggestions, bool isFromField) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion.description),
            onTap: () => _onSuggestionSelected(suggestion, isFromField),
          );
        },
      ),
    );
  }
}