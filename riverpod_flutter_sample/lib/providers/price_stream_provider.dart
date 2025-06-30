import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final coinCapSocketProvider = Provider<WebSocketChannel>((ref) {
  final uri = Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin,ethereum');
  final channel = WebSocketChannel.connect(uri);
  ref.onDispose(() => channel.sink.close());
  return channel;
});

final priceStreamProvider = StreamProvider<Map<String, String>>((ref) {
  final channel = ref.watch(coinCapSocketProvider);
  final latestPrices = <String, String>{};

  return channel.stream.map((event) {
    final decoded = jsonDecode(event) as Map<String, dynamic>;

    // Merge partial update into latestPrices map
    decoded.forEach((k, v) {
      latestPrices[k] = v.toString();
    });

    return Map<String, String>.from(latestPrices); // emit a new copy
  });
});