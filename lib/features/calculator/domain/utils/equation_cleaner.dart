class EquationCleaner {
  EquationCleaner._();

  static void cleanTokens(List<dynamic> items) {
    if (items[0] == ')') items.removeAt(0);

    for (int i = 0; i < items.length - 1; i++) {
      if (items[i].runtimeType == double &&
          items[i + 1].runtimeType == double) {
        items.removeAt(i + 1);
        i--;
      }
    }
  }
}
