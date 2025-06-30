import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../places_services/places_service.dart';

const googleApiKey = 'AIzaSyCgEM67317BMVfo-r82iyVfjXP4kSv8niY'; // keep secure later

final placesServiceProvider = Provider<PlacesService>((ref) {
  final client = ref.watch(apiClientProvider);
  return PlacesService(client, googleApiKey);
});

final placeAutocompleteProvider = FutureProvider.family.autoDispose(
  (ref, String query) async {
    final service = ref.watch(placesServiceProvider);
    return service.getAutocomplete(query);
  },
);

final placeDetailsProvider = FutureProvider.family.autoDispose(
  (ref, String placeId) async {
    final service = ref.watch(placesServiceProvider);
    return service.getPlaceDetails(placeId);
  },
);
