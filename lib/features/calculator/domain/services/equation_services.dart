// Facade for equation services

import 'package:calculator/features/calculator/domain/utils/equation_cleaner.dart';
import 'package:calculator/features/calculator/domain/utils/equation_splitter.dart';
import 'package:calculator/features/calculator/domain/utils/equation_validator.dart';
import 'package:calculator/features/calculator/domain/utils/tokens_transformer.dart';

class EquationServices {
  EquationServices._();

  static List<dynamic> processEquation(String equation) {
    final List<String> rawTokens = EquationSplitter.splitEquation(equation);

    final TokensTransformer tokensTransformer = TokensTransformer();
    tokensTransformer.tokens(rawTokens);
    tokensTransformer.insertMultiplicationSign();

    List<dynamic> items = tokensTransformer.items;

    EquationCleaner.cleanTokens(items);

    if (!EquationValidator.validateTokens(items) || items.isEmpty) return [];

    return items;
  }
}
