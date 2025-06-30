import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'counter_provider.dart';

class MyCounterScreen extends StatefulWidget {
  @override
  State<MyCounterScreen> createState() => _MyCounterScreenState();
}

class _MyCounterScreenState extends State<MyCounterScreen> {
  int _counter = 0;

  void _increment() {
    print("increment called!");
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      counter: _counter,
      increment: _increment,
      child: Scaffold(
        appBar: AppBar(title: Text('InheritedWidget Demo')),
        body: Column(
          children: [
            CounterText(),
            ElevatedButton(
              onPressed: () => CounterProvider.of(context)?.increment(),
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = CounterProvider.of(context)?.counter;
    return Text('Counter: $counter');
  }
}
