import 'package:calculator/common_colors.dart';
import 'package:calculator/equation_provider.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String char;
  final VoidCallback? onPress;
  final Icon? icon;

  const Button({super.key, required this.char, this.onPress, this.icon});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isDeleting = false;
  bool _isInserting = false;

  @override
  Widget build(BuildContext context) {
    final equation = getEquationController(context);

    return GestureDetector(
      onLongPressStart: widget.icon != null
          ? (_) {
              _isDeleting = true;
              _startDeleting(equation);
              setState(() {});
            }
          : (_) {
              _isInserting = true;
              _startInserting(equation);
              setState(() {});
            },
      onLongPressEnd: widget.icon != null
          ? (_) {
              _isDeleting = false;
              setState(() {});
            }
          : (_) {
              _isInserting = false;
              setState(() {});
            },
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            double.tryParse(widget.char) != null
                ? BLUE
                : widget.char == 'C'
                ? Colors.red
                : (widget.icon != null ||
                      widget.char == '=' ||
                      widget.char == '.')
                ? BLACK
                : GREEN,
          ),
        ),
        onPressed:
            widget.onPress ??
            () => widget.icon == null
                ? insertEquation(equation, widget.char)
                : deleteAtCursor(equation),
        child:
            widget.icon ??
            Text(
              widget.char,
              style: TextStyle(
                fontSize: 30,
                color: (widget.char == '=' || widget.char == '.')
                    ? GREEN
                    : WHITE,
                fontWeight: FontWeight.w900,
              ),
            ),
      ),
    );
  }

  TextEditingController getEquationController(BuildContext context) =>
      EquationProvider.of(context)?.equation ?? TextEditingController();

  void insertEquation(TextEditingController equation, String char) {
    final selection = equation.selection;
    final int start = selection.start;
    final int end = selection.end;

    if (start < 0 || start > equation.text.length) return;

    final parts = equation.text.split(RegExp(r'[\+\-\*/\^()√]'));
    final lastNumber = parts.isNotEmpty ? parts.last : '';

    if (char == '.' && lastNumber.contains('.')) return;

    equation.text = equation.text.replaceRange(start, end, char);
    equation.selection = TextSelection.collapsed(offset: start + char.length);
  }

  void deleteAtCursor(TextEditingController equation) {
    final text = equation.text;
    final selection = equation.selection;
    final int start = selection.start;
    final int end = selection.end;

    if (start <= 0 && end == start) return;

    if (end != start) {
      final newText = text.replaceRange(start, end, '');
      equation.text = newText;
      equation.selection = TextSelection.collapsed(offset: start);
    } else {
      final newText = text.replaceRange(start - 1, end, '');
      equation.text = newText;
      equation.selection = TextSelection.collapsed(offset: start - 1);
    }
  }

  Future<void> _startDeleting(TextEditingController equation) async {
    while (_isDeleting && equation.text.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 80));
      if (!_isDeleting) break;
      deleteAtCursor(equation);
    }
  }

  Future<void> _startInserting(TextEditingController equation) async {
    while (_isInserting) {
      await Future.delayed(Duration(milliseconds: 80));
      if (!_isInserting) break;
      insertEquation(equation, widget.char);
    }
  }
}
