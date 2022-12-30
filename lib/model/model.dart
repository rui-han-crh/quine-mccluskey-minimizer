import 'dart:developer';
import 'dart:isolate';

import 'package:proof_map/app_object.dart';
import 'package:proof_map/exceptions/invalid_argument_exception.dart';
import 'package:proof_map/extensions/string_extension.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/immutable_combinational_solver_state.dart';
import 'package:proof_map/model/mutable_combinational_solver_state.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/model/parser.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/utils/messages.dart';
import 'package:proof_map/view/utils/expression_form.dart';

class Model extends AppObject {
  Model(this._parser);

  ExpressionForm expressionForm = ExpressionForm.algebraic;

  MutableCombinationalSolverState combinationalSolverState =
      MutableCombinationalSolverState();

  final List<ImmutableCombinationalSolverState>
      combinationalSolverStateHistory = [];

  final Parser _parser;

  Model._(Parser parser) : _parser = parser;

  void pushCombinationalSolverState() {
    MutableCombinationalSolverState nextState =
        combinationalSolverState.clone();
    combinationalSolverStateHistory.add(combinationalSolverState.toImmutable());
    combinationalSolverState = nextState;
  }

  Future<Answer> solveAlgebraic(String expression,
      {int timeoutSeconds = 10}) async {
    if (expression.isEmpty) {
      throw ArgumentError.value(
          expression, "expression", cannotBeEmptyString.format(["expression"]));
    }

    final ReceivePort port = ReceivePort();

    Term expressionTerm;
    try {
      expressionTerm = _parser.parseAlgebraic(expression);
    } catch (e) {
      return const Answer.empty();
    }

    Isolate isolate =
        await Isolate.spawn(_simplifyToAnswer, [port.sendPort, expressionTerm]);

    Future.delayed(Duration(seconds: timeoutSeconds), () {
      isolate.kill();
      port.sendPort.send(const Answer.empty());
    });

    return await port.first as Answer;
  }

  Future<Answer> solveMinterms(String variables, String indices,
      {int timeoutSeconds = 10}) async {
    Term mintermsExpression;
    Term maxtermsExpression;

    String indicesOfMaxterms =
        _parser.parseMintermsToMaxterms(variables, indices);

    try {
      mintermsExpression =
          _constructExpression(variables, indices, isMinterms: true);
      maxtermsExpression =
          _constructExpression(variables, indicesOfMaxterms, isMinterms: false);
    } on InvalidArgumentException {
      return const Answer.empty();
    }

    final ReceivePort port = ReceivePort();
    Isolate isolate = await Isolate.spawn(_simplifyToAnswer, [
      port.sendPort,
      mintermsExpression,
      mintermsExpression,
      maxtermsExpression
    ]);

    Future.delayed(Duration(seconds: timeoutSeconds), () {
      isolate.kill();
      port.sendPort.send(const Answer.empty());
    });

    return await port.first as Answer;
  }

  Future<Answer> solveMaxterms(String variables, String indices,
      {int timeoutSeconds = 10}) async {
    Term maxtermsExpression;
    Term mintermsExpression;

    String indicesOfMinterms =
        _parser.parseMaxtermsToMinterms(variables, indices);

    try {
      maxtermsExpression =
          _constructExpression(variables, indices, isMinterms: false);
      mintermsExpression =
          _constructExpression(variables, indicesOfMinterms, isMinterms: true);
    } on InvalidArgumentException {
      return const Answer.empty();
    }

    final ReceivePort port = ReceivePort();
    Isolate isolate = await Isolate.spawn(_simplifyToAnswer, [
      port.sendPort,
      maxtermsExpression,
      mintermsExpression,
      maxtermsExpression
    ]);

    Future.delayed(Duration(seconds: timeoutSeconds), () {
      isolate.kill();
      port.sendPort.send(const Answer.empty());
    });

    return await port.first as Answer;
  }

  Term _constructExpression(String variables, String indices,
      {required bool isMinterms}) {
    Term expression;

    if (variables.isEmpty) {
      throw ArgumentError.value(
          variables, "variables", cannotBeEmptyString.format(["variables"]));
    }

    if (indices.isEmpty) {
      throw ArgumentError.value(
          indices, "indices", cannotBeEmptyString.format(["indices"]));
    }

    try {
      if (isMinterms) {
        expression = _parser.parseMinterms(variables, indices);
      } else {
        expression = _parser.parseMaxterms(variables, indices);
      }
    } on InvalidArgumentException {
      rethrow;
    }
    log("Expression constructed");
    return expression;
  }

  void _simplifyToAnswer(List<dynamic> args) async {
    SendPort responsePort = args[0];
    Term expression = args[1];
    Term? expressionCNF;
    Term? expressionDNF;
    if (args.length > 2) {
      expressionDNF = args[2];
      expressionCNF = args[3];
    }

    responsePort.send(Answer(
        conjunctiveNormalForm:
            expressionCNF?.toConjunctiveNormalForm().simplify() ??
                expression.toConjunctiveNormalForm().simplify(),
        disjunctiveNormalForm:
            expressionDNF?.toDisjunctiveNormalForm().simplify() ??
                expression.toDisjunctiveNormalForm().simplify(),
        simplestForm: expression));

    Isolate.exit();
  }
}
