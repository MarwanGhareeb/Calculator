import 'dart:math';
import 'package:flutter/material.dart';

class Calculator {
  final String _input;
  final BuildContext context;
  final List<dynamic> _items = [];

  Calculator(this._input, this.context);

  void splitEquation() {
    final RegExp regex = RegExp(r'((\d+)?\.\d+|\d+|[\+\-\*/√^()])');

    final Iterable<RegExpMatch> matches = regex.allMatches(_input);
    final List<String> rawTokens = matches.map((e) => e.group(0)!).toList();

    if (rawTokens.isEmpty) return;

    for (int i = 0; i < rawTokens.length; i++) {
      final current = rawTokens[i];

      if ((current == '-' || current == '+') && i + 1 < rawTokens.length) {
        final next = rawTokens[i + 1];

        // add 1 between sign and '√' || '(' =====>> in the fst
        if (i == 0 && "√(".contains(next)) {
          _items.add(double.tryParse('${current}1'));
          _items.add(next);
          i++;
          continue;
        }

        // add 1 between sign and '√' || '(' =====>> in the mid
        if (i > 0 && "√(".contains(next)) {
          _items.add('+');
          _items.add(double.tryParse('${current}1'));
          _items.add(next);
          i++;
          continue;
        }

        // assign negative sign to number
        if (i == 0 || "+-*/^(".contains(rawTokens[i - 1])) {
          final combined = '$current${rawTokens[i + 1]}';
          _items.add(double.tryParse(combined) ?? combined);
          i++;
          continue;
        }
      }

      _items.add(double.tryParse(current) ?? current);
    }

    // handle for multiplication () without '*'
    for (int i = 1; i < _items.length; i++) {
      if (((_items[i] == '√' || _items[i] == '(') &&
              _items[i - 1].runtimeType != String) ||
          (_items[i - 1] == ')' && _items[i].runtimeType != String)) {
        _items.insert(i, '*');
        i++;
      }

      if ((_items[i - 1] == ')' && _items[i] == '(')) {
        _items.insert(i, '*');
        i++;
      }
    }

    if (_items[0] == ')') _items.removeAt(0);

    for (int i = 0; i < _items.length - 1; i++) {
      if (_items[i].runtimeType == double &&
          _items[i + 1].runtimeType == double) {
        _items.removeAt(i + 1);
        i--;
      }
    }
  }

  bool handle() {
    // handle operation side operation
    for (int i = 0; i < _items.length - 1; i++) {
      if ("+-*/".contains(_items[i].toString()) &&
          "+-*/".contains(_items[i + 1].toString())) {
        snackBar(context, "One Operation Between Two doublebers");
        return false;
      }
    }

    if (_items.length == 1 && "+-*/^√".contains(_items[0])) {
      snackBar(context, "Expression cannot contains operations only");
      return false;
    }

    // handle operations in last of equation
    if (_items.isNotEmpty && "+-*/^√".contains(_items.first.toString())) {
      snackBar(context, "Expression cannot start with an operator");
      return false;
    }

    // handle operations in last of equation
    if (_items.isNotEmpty && "+-*/^√".contains(_items.last.toString())) {
      snackBar(context, "Expression cannot end with an operator");
      return false;
    }

    return true;
  }

  double _add(double left, double right) => left + right;

  double _subtract(double left, double right) => left - right;

  double _multiply(double left, double right) => left * right;

  double _division(double left, double right) => right == 0
      ? throw Exception("Devision by 0 is Impossible.")
      : left / right;

  num _power(double left, double right) => pow(left, right);

  double _root(double right) => sqrt(right).isNaN
      ? throw Exception("A negative sign cannot be inside a square root.")
      : sqrt(right);

  double? _calculate(List items) {
    List<Map<String, Function>> operators = [
      {"(": _calculate},
      {"√": _root},
      {"^": _power},
      {"*": _multiply, "/": _division},
      {"+": _add, "-": _subtract},
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
              snackBar(context, "mis matched brackets");
              return null;
            }

            if (operation == _root) {
              try {
                items[pos + 1] = operation(items[pos + 1]);
                items.removeAt(pos);
                continue;
              } catch (e) {
                snackBar(
                  context,
                  'A negative sign cannot be inside a square root',
                );
                return null;
              }
            }

            try {
              items[pos + 1] = operation(items[pos - 1], items[pos + 1]);
              items.removeAt(pos - 1);
              items.removeAt(pos - 1);
            } catch (e) {
              snackBar(
                context,
                operation == _division
                    ? 'Devision by 0 is Impossible'
                    : "Error found",
              );
              return null;
            }
          }
        } while (pos >= 0);
      }
    }

    return items[0];
  }

  double? calculator() {
    _items.clear();
    splitEquation();
    if (!handle() || _items.isEmpty) return null;
    List tempItems = List.from(_items);
    double? output = _calculate(tempItems);
    if (output == double.infinity) {
      snackBar(context, "Result is too larg 'infinity' ∞");
      return null;
    }
    return output;
  }

  snackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
