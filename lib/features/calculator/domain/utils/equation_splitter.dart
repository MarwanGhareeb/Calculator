class EquationSplitter {
  static List<String> splitEquation(String equation) {
    final RegExp regex = RegExp(r'((\d+)?\.\d+|\d+|[\+\-\*/√^()])');

    final Iterable<RegExpMatch> matches = regex.allMatches(equation);
    final List<String> rawTokens = matches.map((e) => e.group(0)!).toList();

    if (rawTokens.isEmpty) throw Exception('Equation is Empty');

    return rawTokens;
  }
}
