// lib/features/ipo/presentation/providers/ipo_provider.dart

import 'package:flutter_hooks_riverpod_app/features/ipo/domain/ipo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/ipo_service.dart';
import '../../data/iporesponse.dart';

// Provide the IPO Service using the injected ApiClient
final ipoServiceProvider = Provider<IpoService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return IpoService(apiClient);
});

final ipoDataProvider = FutureProvider<IpoResponse>((ref) {
  print("my future provider ipoDataProvider called");
  final repository = ref.read(ipoRepositoryProvider);
  return repository.getIpoDataFromRepository();
});
