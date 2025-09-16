import 'package:calculator/features/calculator/domain/services/equation_services.dart';
import 'package:calculator/features/calculator/domain/operations/math_operations.dart';

class Calculator {
  Calculator._();

  static double? _calculate(List items) {
    List<Map<String, Function>> operators = [
      {"(": _calculate},
      {"√": MathOperations.root},
      {"^": MathOperations.power},
      {"*": MathOperations.multiply, "/": MathOperations.division},
      {"+": MathOperations.add, "-": MathOperations.subtract},
    ];

    Map<int, int> rounds(List items) {
      List<int> stack = [];
      Map<int, int> pairs = {};
      for (int i = 0; i < items.length; i++) {
        if (items[i] == '(') stack.add(i);
        if (items[i] == ')') pairs[stack.removeLast()] = i;
      }
      return pairs;
    }

    try {
      while (items.length > 1) {
        for (var precedence in operators) {
          int pos = 0;
          do {
            Map<int, int> pairs = rounds(items);
            pos = items.indexWhere((e) => precedence.containsKey(e));
            if (pos >= 0) {
              final operation = precedence[items[pos]]!;

              try {
                if (operation == _calculate) {
                  items.replaceRange(pos, pairs[pos]! + 1, [
                    _calculate(items.sublist(pos + 1, pairs[pos]!)),
                  ]);
                  continue;
                }
              } catch (e) {
                throw Exception("mis matched brackets");
              }

              if (operation == MathOperations.root) {
                try {
                  items[pos + 1] = operation(items[pos + 1]);
                  items.removeAt(pos);
                  continue;
                } catch (e) {
                  throw Exception(
                    'A negative sign cannot be inside a square root',
                  );
                }
              }

              try {
                items[pos + 1] = operation(items[pos - 1], items[pos + 1]);
                items.removeAt(pos - 1);
                items.removeAt(pos - 1);
              } catch (e) {
                throw Exception(
                  operation == MathOperations.division
                      ? 'Devision by 0 is Impossible'
                      : "Error found",
                );
              }
            }
          } while (pos >= 0);
        }
      }
    } catch (e) {
      throw Exception("Invalid input or calculation error");
    }

    return items[0];
  }

  static double? calculator(String equation) {
    final List<dynamic> items = EquationServices.processEquation(equation);

    // assigning the cleaned tokens to _items
    if (items.isEmpty) return null;

    double? output = _calculate(items);
    if (output == double.infinity) {
      throw Exception("Result is too larg 'infinity' ∞");
    }
    return output;
  }
}
