import 'dart:isolate';

import 'package:proof_map/app_object.dart';
import 'package:proof_map/exceptions/invalid_argument_exception.dart';
import 'package:proof_map/extensions/string_extension.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/combinational_solver_state.dart';
import 'package:proof_map/model/immutable_combinational_solver_state.dart';
import 'package:proof_map/model/mutable_combinational_solver_state.dart';
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

  Future<Answer> solveAlgebraic(String expression) async {
    if (expression.isEmpty) {
      throw ArgumentError.value(
          expression, "expression", cannotBeEmptyString.format(["expression"]));
    }

    final ReceivePort port = ReceivePort();
    Isolate isolate = await Isolate.spawn(
        _simplifyToAnswer, [port.sendPort, _parser.parseAlgebraic(expression)]);

    Future.delayed(const Duration(seconds: 30), () {
      isolate.kill();
      port.sendPort.send(const Answer.empty());
    });

    return await port.first as Answer;
  }

  // Answer solveMinterms(String variables, String indices) {
  //   Term expression;
  //   try {
  //     expression = _parser.parseMinterms(variables, indices);
  //   } on InvalidArgumentException {
  //     rethrow;
  //   }

  //   return _simplifyToAnswer(expression);
  // }

  void _simplifyToAnswer(List<dynamic> args) async {
    SendPort responsePort = args[0];
    Term expression = args[1];

    responsePort.send(Answer(
        conjunctiveNormalForm: expression.toConjunctiveNormalForm().simplify(),
        disjunctiveNormalForm: expression.toDisjunctiveNormalForm().simplify(),
        simplestForm: expression));

    Isolate.exit();
  }
}
