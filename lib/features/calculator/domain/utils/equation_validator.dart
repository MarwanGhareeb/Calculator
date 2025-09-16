class EquationValidator {
  EquationValidator._();

  static bool validateTokens(List<dynamic> items) {
    // validateTokens operation side operation
    for (int i = 0; i < items.length - 1; i++) {
      if ("+-*/".contains(items[i].toString()) &&
          "+-*/".contains(items[i + 1].toString())) {
        throw Exception("One operation can't follow another");
      }
    }

    if (items.length == 1 && "+-*/^√".contains(items[0].toString())) {
      throw Exception("Expression can't contains operations only");
    }

    // validateTokens operations in last of equation
    if (items.isNotEmpty && "+-*/^".contains(items.first.toString())) {
      throw Exception("Expression can't start with an operator");
    }

    // validateTokens operations in last of equation
    if (items.isNotEmpty && "+-*/^√".contains(items.last.toString())) {
      throw Exception("Expression can't end with an operator");
    }

    return true;
  }
}
