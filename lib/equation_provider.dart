import 'package:flutter/material.dart';

class EquationProvider extends InheritedWidget {
  final TextEditingController equation;

  const EquationProvider({
    super.key,
    required super.child,
    required this.equation
  });

  static EquationProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EquationProvider>();
  }

  @override
  bool updateShouldNotify(EquationProvider oldWidget) {
    return equation.text != oldWidget.equation.text;
  }
}
