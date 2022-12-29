import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/immutable_combinational_solver_state.dart';

/// A class that represents the state of a [CombinationalSolver].
abstract class CombinationalSolverState {
  Answer get answer;
  set answer(Answer newAnswer);

  String get algebraicExpression;
  set algebraicExpression(String newAlgebraicExpression);

  String get mintermVariables;
  set mintermVariables(String newMintermVariables);

  String get maxtermVariables;
  set maxtermVariables(String newMaxtermVariables);

  List<String> get termHeaders;
  set termHeaders(List<String> newTermHeaders);

  ImmutableCombinationalSolverState toImmutable();
}
