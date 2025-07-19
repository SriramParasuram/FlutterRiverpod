import 'dart:isolate';
import 'dart:math';

Future<List<int>> computePrimesInIsolate(int start, int end) async {
  final receivePort = ReceivePort();
  final stopwatch = Stopwatch()..start();

  await Isolate.spawn(_isolateEntry, [receivePort.sendPort, start, end]);

  final result = await receivePort.first as List<int>;

  stopwatch.stop();
  print("⏱️ Time taken in isolate: ${stopwatch.elapsedMilliseconds}ms");

  return result;
}

void _isolateEntry(List<dynamic> args) {
  final sendPort = args[0] as SendPort;
  final start = args[1] as int;
  final end = args[2] as int;

  final primes = <int>[];
  for (int i = start; i <= end; i++) {
    if (_isPrime(i)) primes.add(i);
  }

  sendPort.send(primes);
}

bool _isPrime(int number) {
  if (number < 2) return false;
  for (int i = 2; i <= sqrt(number).toInt(); i++) {
    if (number % i == 0) return false;
  }
  return true;
}