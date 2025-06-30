import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../places_model/places_model.dart';

class PlacesService {
  final ApiClient _client;
  final String _apiKey;

  PlacesService(this._client, this._apiKey);

  Future<List<PlaceAutocompleteResult>> getAutocomplete(String input) async {
    final res = await _client.dio.get(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      queryParameters: {
        'input': input,
        'key': _apiKey,
        'components': 'country:in',
      },
    );

    if (res.statusCode == 200 && res.data['status'] == 'OK') {
      final List predictions = res.data['predictions'];
      return predictions
          .map((e) => PlaceAutocompleteResult.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get autocomplete');
    }
  }

  Future<PlaceDetailsResult> getPlaceDetails(String placeId) async {
    final res = await _client.dio.get(
      'https://maps.googleapis.com/maps/api/place/details/json',
      queryParameters: {
        'place_id': placeId,
        'key': _apiKey,
      },
    );

    if (res.statusCode == 200 && res.data['status'] == 'OK') {
      return PlaceDetailsResult.fromJson(res.data['result']);
    } else {
      throw Exception('Failed to get place details');
    }
  }

  Future<List<dynamic>> getPolylinePoints({
    required String fromLat,
    required String fromLng,
    required String toLat,
    required String toLng,
  }) async {
    final res = await _client.dio.get(
      'https://maps.googleapis.com/maps/api/directions/json',
      queryParameters: {
        'origin': '$fromLat,$fromLng',
        'destination': '$toLat,$toLng',
        'mode': 'driving',
        'key': _apiKey,
      },
    );

    if (res.statusCode == 200 && res.data['status'] == 'OK') {
      return res.data['routes'];
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  Future<String?> getAddressFromLatLng({
    required double lat,
    required double lng,
  }) async {
    final res = await _client.dio.get(
      'https://maps.googleapis.com/maps/api/geocode/json',
      queryParameters: {
        'latlng': '$lat,$lng',
        'key': _apiKey,
      },
    );

    if (res.statusCode == 200 && res.data['status'] == 'OK') {
      final results = res.data['results'];
      if (results.isNotEmpty) {
        return results[0]['formatted_address'];
      }
    }
    return null;
  }
}
