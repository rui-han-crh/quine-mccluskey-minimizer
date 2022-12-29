import 'package:proof_map/model/answer.dart';

import 'combinational_solver_state.dart';

/// An immutable implementation of [CombinationalSolverState]. This is useful for
/// when you want to save the current state of a [MutableCombinationalSolverState]
/// to a [Model] and prevent further mutations.
class ImmutableCombinationalSolverState extends CombinationalSolverState {
  final Answer _answer;
  final String _algebraicExpression;
  final String _mintermVariables;
  final String _maxtermVariables;
  final List<String> _termHeaders;

  @override
  Answer get answer => _answer;
  @override
  set answer(Answer newAnswer) =>
      throw UnsupportedError("ImmutableCombinationalSolverState is immutable");

  @override
  String get algebraicExpression => _algebraicExpression;
  @override
  set algebraicExpression(String newAlgebraicExpression) =>
      throw UnsupportedError("ImmutableCombinationalSolverState is immutable");

  @override
  String get maxtermVariables => _maxtermVariables;
  @override
  set maxtermVariables(String newMaxtermVariables) =>
      throw UnsupportedError("ImmutableCombinationalSolverState is immutable");

  @override
  String get mintermVariables => _mintermVariables;
  @override
  set mintermVariables(String newMintermVariables) =>
      throw UnsupportedError("ImmutableCombinationalSolverState is immutable");

  @override
  List<String> get termHeaders => _termHeaders;
  @override
  set termHeaders(List<String> newTermHeaders) =>
      throw UnsupportedError("ImmutableCombinationalSolverState is immutable");

  /// Creates a new [ImmutableCombinationalSolverState] with the given parameters.
  ImmutableCombinationalSolverState(
      {required Answer answer,
      required String algebraicExpression,
      required String mintermVariables,
      required String maxtermVariables,
      required List<String> termHeaders})
      : _answer = answer,
        _algebraicExpression = algebraicExpression,
        _mintermVariables = mintermVariables,
        _maxtermVariables = maxtermVariables,
        _termHeaders = termHeaders,
        super();

  @override
  ImmutableCombinationalSolverState toImmutable() {
    return this;
  }
}
