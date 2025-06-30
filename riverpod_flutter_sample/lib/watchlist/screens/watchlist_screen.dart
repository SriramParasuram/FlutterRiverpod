import 'package:flutter/material.dart';
import 'package:flutter_hooks_riverpod_app/constants/app_constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/tick_data.dart';
import '../provider/streaming_provider.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final symbols = AppConstants.watchListItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: ListView.builder(
        itemCount: symbols.length,
        itemBuilder: (context, index) {
          final symbol = symbols.keys.elementAt(index);
          final company = symbols[symbol]!;

          return Consumer(
            builder: (context, ref, _) {
              final tickAsync = ref.watch(tickStreamProvider(symbol));

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                      ).createShader(bounds);
                    },
                    child: Text(
                      company,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  subtitle: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.indigo, Colors.cyan],
                      ).createShader(bounds);
                    },
                    child: Text(
                      symbol,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  trailing: tickAsync.when(
                    data: (tick) {
                      Color color;
                      if (tick.changePercent > 0) {
                        color = Colors.green;
                      } else if (tick.changePercent < 0) {
                        color = Colors.red;
                      } else {
                        color = Colors.grey;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('₹${tick.ltp}',
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text('${tick.change} (${tick.changePercent}%)',
                              style: TextStyle(color: color, fontSize: 14)),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(strokeWidth: 2),
                    error: (e, _) => const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}