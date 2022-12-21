import 'package:proof_map/app_object.dart';
import 'package:proof_map/exceptions/invalid_argument_exception.dart';
import 'package:proof_map/extensions/string_extension.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/mutable_combinational_storage.dart';
import 'package:proof_map/model/parser.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/utils/messages.dart';
import 'package:proof_map/view/utils/expression_form.dart';

class Model extends AppObject {
  Model(this._parser);

  ExpressionForm expressionForm = ExpressionForm.algebraic;

  final MutableCombinationalStorage storage = MutableCombinationalStorage();

  final Parser _parser;

  Model._(Parser parser) : _parser = parser;

  void replace(
      {String? algebraicExpression,
      String? mintermVariables,
      String? maxtermVariables,
      Answer? answer}) {
    storage.algebraicExpression =
        algebraicExpression ?? storage.algebraicExpression;
    storage.mintermVariables = mintermVariables ?? storage.mintermVariables;
    storage.maxtermVariables = maxtermVariables ?? storage.maxtermVariables;
    storage.answer = answer ?? storage.answer;
  }

  Future<Answer> solveAlgebraic(String expression) async {
    if (expression.isEmpty) {
      throw ArgumentError.value(
          expression, "expression", cannotBeEmptyString.format(["expression"]));
    }

    return _simplifyToAnswer(_parser.parseAlgebraic(expression));
  }

  Future<Answer> solveMinterms(String variables, String indices) async {
    Term expression;
    try {
      expression = _parser.parseMinterms(variables, indices);
    } on InvalidArgumentException {
      rethrow;
    }

    return _simplifyToAnswer(expression);
  }

  Answer _simplifyToAnswer(Term expression) {
    Term simplified = expression.simplify();

    return Answer(
        conjunctiveNormalForm: simplified.toConjunctiveNormalForm(),
        disjunctiveNormalForm: simplified.toDisjunctiveNormalForm(),
        simplestForm: simplified);
  }
}
