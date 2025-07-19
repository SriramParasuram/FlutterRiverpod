import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'prime_provider.dart';

class PrimeScreen extends ConsumerStatefulWidget {
  const PrimeScreen({super.key});

  @override
  ConsumerState<PrimeScreen> createState() => _PrimeScreenState();
}

class _PrimeScreenState extends ConsumerState<PrimeScreen> {
  final _startController = TextEditingController(text: "1");
  final _endController = TextEditingController(text: "10000");

  @override
  Widget build(BuildContext context) {
    final asyncPrimes = ref.watch(primeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Prime Finder with Isolate")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _startController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Start"),
            ),
            TextField(
              controller: _endController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "End"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final start = int.tryParse(_startController.text) ?? 1;
                final end = int.tryParse(_endController.text) ?? 100;
                ref.read(primeNotifierProvider.notifier)
                  ..setRange(start, end)
                  ..findPrimes();
              },
              child: const Text("Find Primes"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: asyncPrimes.when(
                data: (primes) => primes.isEmpty
                    ? const Text("No primes yet.")
                    : ListView.builder(
                        itemCount: primes.length.clamp(0, 100),
                        itemBuilder: (_, i) =>
                            ListTile(title: Text(primes[i].toString())),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text("❌ Error: $e"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
