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
      {int timeoutSeconds = 10,
      bool computeDnf = true,
      bool computeCnf = true}) async {
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

    Isolate isolate = await Isolate.spawn(_simplifyToAnswer, [
      port.sendPort,
      expressionTerm,
      null,
      null,
      computeDnf,
      computeCnf,
    ]);

    Future.delayed(Duration(seconds: timeoutSeconds), () {
      isolate.kill();
      port.sendPort.send(const Answer.empty());
    });

    return await port.first as Answer;
  }

  Future<Answer> solveMinterms(String variables, String indices,
      {int timeoutSeconds = 10, bool computeMaxterms = true}) async {
    Term mintermsExpression;
    Term? maxtermsExpression;

    String indicesOfMaxterms =
        _parser.parseMintermsToMaxterms(variables, indices);

    try {
      mintermsExpression =
          _constructExpression(variables, indices, isMinterms: true);
      if (computeMaxterms) {
        maxtermsExpression = _constructExpression(variables, indicesOfMaxterms,
            isMinterms: false);
      }
    } on InvalidArgumentException {
      return const Answer.empty();
    }

    final ReceivePort port = ReceivePort();
    Isolate isolate = await Isolate.spawn(_simplifyToAnswer, [
      port.sendPort,
      mintermsExpression,
      mintermsExpression,
      maxtermsExpression,
      true,
      computeMaxterms,
    ]);

    Future.delayed(Duration(seconds: timeoutSeconds), () {
      isolate.kill();
      port.sendPort.send(const Answer.empty());
    });

    return await port.first as Answer;
  }

  Future<Answer> solveMaxterms(String variables, String indices,
      {int timeoutSeconds = 10, bool computeMinterms = true}) async {
    Term maxtermsExpression;
    Term? mintermsExpression;

    String indicesOfMinterms =
        _parser.parseMaxtermsToMinterms(variables, indices);

    try {
      maxtermsExpression =
          _constructExpression(variables, indices, isMinterms: false);
      if (computeMinterms) {
        mintermsExpression = _constructExpression(variables, indicesOfMinterms,
            isMinterms: true);
      }
    } on InvalidArgumentException {
      return const Answer.empty();
    }

    final ReceivePort port = ReceivePort();
    Isolate isolate = await Isolate.spawn(_simplifyToAnswer, [
      port.sendPort,
      maxtermsExpression,
      mintermsExpression,
      maxtermsExpression,
      computeMinterms,
      true,
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

  // A mess: basically, this is an Isolate method that lives in a worker thread,
  // the args is a list of arguments that are passed to the isolate. The first
  // argument is the SendPort, which is used to send the result back to the
  // main thread. The second argument is the expression, which is the expression
  // to be simplified. The third argument is the expression in DNF, which is
  // passed if the expression is already in DNF. The fourth argument is the
  // expression in CNF, which is passed if the expression is already in CNF.
  // The DNF and CNF may be null, if you want to compute them from the expression.
  // The fifth argument is a boolean that indicates whether the DNF should be
  // computed. The sixth argument is a boolean that indicates whether the CNF
  // should be computed.
  /// Args: [SendPort, expression, expressionCNF?, expressionDNF?, computeDNF, computeCNF]
  void _simplifyToAnswer(List<dynamic> args) async {
    SendPort responsePort = args[0];
    Term expression = args[1];
    Term? expressionDNF = args[2];
    Term? expressionCNF = args[3];
    bool computeDNF = args[4];
    bool computeCNF = args[5];

    responsePort.send(Answer(
        conjunctiveNormalForm: computeCNF
            ? expressionCNF?.toConjunctiveNormalForm().simplify() ??
                expression.toConjunctiveNormalForm().simplify()
            : null,
        disjunctiveNormalForm: computeDNF
            ? expressionDNF?.toDisjunctiveNormalForm().simplify() ??
                expression.toDisjunctiveNormalForm().simplify()
            : null,
        simplestForm: expression));

    Isolate.exit();
  }
}
