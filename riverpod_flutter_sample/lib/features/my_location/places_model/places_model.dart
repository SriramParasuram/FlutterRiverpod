class PlaceAutocompleteResult {
  final String description;
  final String placeId;

  PlaceAutocompleteResult({required this.description, required this.placeId});

  factory PlaceAutocompleteResult.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResult(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}

class PlaceDetailsResult {
  final double lat;
  final double lng;

  PlaceDetailsResult({required this.lat, required this.lng});

  factory PlaceDetailsResult.fromJson(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    return PlaceDetailsResult(
      lat: location['lat'],
      lng: location['lng'],
    );
  }
}