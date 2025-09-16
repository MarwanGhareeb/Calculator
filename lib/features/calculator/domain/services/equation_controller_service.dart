import 'package:flutter/material.dart';

class EquationControllerService {
  bool _isDeleting = false;
  bool _isInserting = false;

  EquationControllerService();

  void stopDeleting() => _isDeleting = false;
  void stopInserting() => _isInserting = false;

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

  Future<void> startDeleting(TextEditingController equation) async {
    _isDeleting = true;
    while (_isDeleting && equation.text.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 80));
      if (!_isDeleting) break;
      deleteAtCursor(equation);
    }
  }

  Future<void> startInserting(
    TextEditingController equation,
    String char,
  ) async {
    _isInserting = true;
    while (_isInserting) {
      if ("=C.".contains(char)) break;
      insertEquation(equation, char);
      await Future.delayed(Duration(milliseconds: 80));
      if (!_isInserting) break;
    }
  }
}
