import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'prime_isolate.dart';

final primeNotifierProvider =
AsyncNotifierProvider<PrimeNotifier, List<int>>(PrimeNotifier.new);

class PrimeNotifier extends AsyncNotifier<List<int>> {
  int start = 1;
  int end = 100;

  void setRange(int s, int e) {
    start = s;
    end = e;
  }

  @override
  Future<List<int>> build() async {
    return [];
  }

  Future<void> findPrimes() async {
    state = const AsyncLoading();
    final result = await computePrimesInIsolate(start, end);
    state = AsyncData(result);
  }
}