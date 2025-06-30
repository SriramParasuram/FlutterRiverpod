import 'package:flutter/cupertino.dart';

class CounterProvider extends InheritedWidget {
  final int counter;
  final void Function() increment;

  const CounterProvider({
    required this.counter,
    required this.increment,
    required Widget child,
  }) : super(child: child);

  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    return counter != oldWidget.counter;
  }
}