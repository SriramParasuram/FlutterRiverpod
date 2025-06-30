import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ipo_provider.dart';

class IpoScreenRiverPod extends ConsumerStatefulWidget {
  const IpoScreenRiverPod({super.key});

  @override
  ConsumerState<IpoScreenRiverPod> createState() => _IpoScreenState();
}

class _IpoScreenState extends ConsumerState<IpoScreenRiverPod> {
  @override
  Widget build(BuildContext context) {
    final ipoResponse = ref.watch(ipoDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("IPO Listings"),
      ),
      body: ipoResponse.when(
        data: (ipoData) {
          final activeList = ipoData.active;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: activeList.length,
            itemBuilder: (context, index) {
              final ipo = activeList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    ipo.companyName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(ipo.iPOInfo),
                  trailing: Text(
                    "₹${ipo.minPrice?.toStringAsFixed(1)} - ₹${ipo.maxPrice?.toStringAsFixed(1)}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
