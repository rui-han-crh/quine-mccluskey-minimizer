import 'dart:math';

import 'package:proof_map/app_object.dart';
import 'package:proof_map/exceptions/invalid_argument_exception.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/parser.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/view/utils/expression_form.dart';

class Model extends AppObject {
  Parser _parser;

  Model(this._parser);

  ExpressionForm get expressionForm => ExpressionForm.sumOfProducts;

  Future<String> simplifyBooleanExpression(String expression) async {
    if (expression.isEmpty) {
      return "";
    }
    return _parser.toBooleanExpression(expression).simplify().statement;
  }

  Future<String> simplifyFromMinterms(String variables, String indices) async {
    Term expression;
    try {
      expression = _parser.fromMintermsToExpression(variables, indices);
    } on InvalidArgumentException catch (e) {
      return e.errorMessage;
    }

    Term simplified = expression.simplify();

    if (simplified is JoinedTerm &&
        simplified.enclosedTerms
                .whereType<JoinedTerm>()
                .map((e) => e.enclosedTerms.length)
                .fold(0, max) >
            4) {
      return simplified.statement.split(RegExp("(?=\\+)")).join("\n");
    }

    return simplified.statement;
  }
}
