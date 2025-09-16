class TokensTransformer {
  final List<dynamic> _items = [];

  List<dynamic> get items => _items;

  void tokens(List<String> rawTokens) {
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
  }

  void insertMultiplicationSign() {
    for (int i = 1; i < _items.length; i++) {
      if (((_items[i] == '√' || _items[i] == '(') &&
              _items[i - 1].runtimeType != String) ||
          (_items[i - 1] == ')' && _items[i].runtimeType != String) ||
          (_items[i - 1] == ')' && _items[i] == '√')) {
        _items.insert(i, '*');
        // i++;
      }

      if ((_items[i - 1] == ')' && _items[i] == '(')) {
        _items.insert(i, '*');
        i++;
      }
    }
  }
}
