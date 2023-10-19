import 'package:flutter/material.dart';

class CountProvider extends InheritedWidget {
  const CountProvider({super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
