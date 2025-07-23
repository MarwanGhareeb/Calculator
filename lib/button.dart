import 'package:calculator/common_code.dart';
import 'package:calculator/equation_provider.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String char;
  final VoidCallback? onPress;
  final Icon? icon;

  const Button({super.key, required this.char, this.onPress, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          double.tryParse(char) != null
              ? blue
              : char == 'C'
              ? Colors.red
              : (icon != null || char == '=' || char == '.')
              ? black
              : green,
        ),
      ),
      onPressed:
          onPress ??
          () => icon == null
              ? insertEquation(context, char)
              : deleteAtCursor(context),
      child:
          icon ??
          Text(
            char,
            style: TextStyle(
              fontSize: 30,
              color: (char == '=' || char == '.') ? green : white,
              fontWeight: FontWeight.w900,
            ),
          ),
    );
  }

  TextEditingController controller(BuildContext context) {
    final provider = EquationProvider.of(context);

    return provider?.equation ?? TextEditingController();
  }

  void insertEquation(BuildContext context, String char) {
    final TextEditingController equation = controller(context);

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

  void deleteAtCursor(BuildContext context) {
    final TextEditingController equation = controller(context);

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
}
