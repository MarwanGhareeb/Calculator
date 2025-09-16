import 'dart:math';

class MathOperations {
  MathOperations._();

  static double add(double left, double right) => left + right;

  static double subtract(double left, double right) => left - right;

  static double multiply(double left, double right) => left * right;

  static double division(double left, double right) => right == 0
      ? throw Exception("Devision by 0 is Impossible.")
      : left / right;

  static num power(double left, double right) => pow(left, right);

  static double root(double right) => sqrt(right).isNaN
      ? throw Exception("A negative sign cannot be inside a square root.")
      : sqrt(right);
}
