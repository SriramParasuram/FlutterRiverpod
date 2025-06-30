import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/price_stream_provider.dart';

class PriceScreen extends HookConsumerWidget {
  const PriceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("we have reached here!!");
    final priceAsync = ref.watch(priceStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Live Prices')),
      body: priceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('❌ Error: $err')),
        data: (priceMap) {
          if (priceMap.isEmpty) {
            return const Center(child: Text("Waiting for price updates..."));
          }

          final filtered = priceMap.entries.where((entry) {
            return double.tryParse(entry.value) != null;
          }).toList();

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final entry = filtered[index];
              return ListTile(
                title: Text(entry.key.toUpperCase()),
                trailing: Text(
                  "\$${entry.value}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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