import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/calculator/presentation/screens/calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    ),
  );
}
