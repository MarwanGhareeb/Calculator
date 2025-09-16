import 'package:calculator/core/constants.dart';
import 'package:calculator/features/calculator/domain/services/equation_controller_service.dart';
import 'package:calculator/features/calculator/domain/services/equation_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final TextEditingController equation = _getEquationController(context);

    final EquationControllerService equationControllerService =
        EquationControllerService();

    return GestureDetector(
      onLongPressStart: widget.icon != null
          ? (_) => equationControllerService.startDeleting(equation)
          : (_) =>
                equationControllerService.startInserting(equation, widget.char),
      onLongPressEnd: widget.icon != null
          ? (_) => equationControllerService.stopDeleting()
          : (_) => equationControllerService.stopInserting(),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            double.tryParse(widget.char) != null
                ? GREY
                : widget.char == 'C'
                ? Colors.red
                : (widget.icon != null ||
                      widget.char == '=' ||
                      widget.char == '.')
                ? BLUE
                : GREEN,
          ),
        ),
        onPressed:
            widget.onPress ??
            () => widget.icon == null
                ? equationControllerService.insertEquation(
                    equation,
                    widget.char,
                  )
                : equationControllerService.deleteAtCursor(equation),
        child:
            widget.icon ??
            Text(
              widget.char,
              style: TextStyle(
                fontSize: 30,
                color: (widget.char == '=' || widget.char == '.')
                    ? WHITE
                    : WHITE,
                fontWeight: FontWeight.w900,
              ),
            ),
      ),
    );
  }

  TextEditingController _getEquationController(BuildContext context) =>
      EquationProvider.of(context)?.equation ?? TextEditingController();
}
