
import 'dart:async';
import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/tick_data.dart';
import '../notifier/watchlist_notifier.dart';
import '../state/watchlist_state.dart';

final tickStreamProvider = StreamProvider.autoDispose.family<TickData, String>((ref, symbol) {
  final random = Random();



  return Stream<TickData>.periodic(const Duration(seconds: 1), (_) {
    final changePercent = (random.nextDouble() * 20) - 10;
    final change = (random.nextDouble() * 1000) - 500;
    final ltp = 1000 + change;

    print('🟢 Stream started for $symbol and ltp is $ltp');

    return TickData(
      ltp: double.parse(ltp.toStringAsFixed(2)),
      change: double.parse(change.toStringAsFixed(2)),
      changePercent: double.parse(changePercent.toStringAsFixed(2)),
    );
  });
});

final watchlistProvider =
StateNotifierProvider<WatchlistNotifier, WatchlistState>((ref) {
  return WatchlistNotifier();
});
