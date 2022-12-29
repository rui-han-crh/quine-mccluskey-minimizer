import 'dart:developer';

import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/combinational_solver_state.dart';
import 'package:proof_map/model/immutable_combinational_solver_state.dart';

/// A mutable implementation of [CombinationalSolverState]. This is useful for when
/// you want to mutate the state of a [CombinationalSolverState] during runtime while
/// the data is actively changing.
class MutableCombinationalSolverState extends CombinationalSolverState {
  Answer _answer = const Answer.empty();
  String _algebraicExpression = "";
  String _mintermVariables = "";
  String _mintermIndices = "";
  String _maxtermVariables = "";
  String _maxtermIndices = "";
  List<String> _termHeaders = [];

  @override
  Answer get answer => _answer;
  @override
  set answer(Answer newAnswer) => _answer = newAnswer;

  @override
  String get algebraicExpression => _algebraicExpression;
  @override
  set algebraicExpression(String newAlgebraicExpression) =>
      _algebraicExpression = newAlgebraicExpression;

  @override
  String get mintermVariables => _mintermVariables;
  @override
  set mintermVariables(String newMintermVariables) {
    _mintermVariables = newMintermVariables;
    log("mintermVariables: $newMintermVariables");
  }

  @override
  String get mintermIndices => _mintermIndices;
  @override
  set mintermIndices(String newMintermIndices) {
    _mintermIndices = newMintermIndices;
    log("mintermIndices: $newMintermIndices");
  }

  @override
  String get maxtermVariables => _maxtermVariables;
  @override
  set maxtermVariables(String newMaxtermVariables) =>
      _maxtermVariables = newMaxtermVariables;

  @override
  String get maxtermIndices => _maxtermIndices;
  @override
  set maxtermIndices(String newMaxtermIndices) =>
      _maxtermIndices = newMaxtermIndices;

  @override
  List<String> get termHeaders => _termHeaders;
  @override
  set termHeaders(List<String> newTermHeaders) => _termHeaders = newTermHeaders;

  MutableCombinationalSolverState();

  /// Returns a new [ImmutableCombinationalSolverState] with the current state of this
  /// [MutableCombinationalSolverState]. This is useful for when you want to
  /// save the current state of this [MutableCombinationalSolverState] to a
  /// [Model].
  ImmutableCombinationalSolverState toImmutable() {
    return ImmutableCombinationalSolverState(
        answer: _answer,
        algebraicExpression: _algebraicExpression,
        mintermVariables: _mintermVariables,
        mintermIndices: _mintermIndices,
        maxtermVariables: _maxtermVariables,
        maxtermIndices: _maxtermIndices,
        termHeaders: _termHeaders);
  }

  /// Creates a new [MutableCombinationalSolverState] from an [ImmutableCombinationalSolverState].
  /// This is useful for when you want to copy an [ImmutableCombinationalSolverState] from
  /// a [Model]'s [CombinationalSolverState] history for editi
  MutableCombinationalSolverState.fromImmutable(
      ImmutableCombinationalSolverState immutableState) {
    _answer = immutableState.answer;
    _algebraicExpression = immutableState.algebraicExpression;
    _mintermVariables = immutableState.mintermVariables;
    _maxtermVariables = immutableState.maxtermVariables;
    _termHeaders = immutableState.termHeaders;
  }

  MutableCombinationalSolverState clone() {
    return MutableCombinationalSolverState()
      ..answer = _answer
      ..algebraicExpression = _algebraicExpression
      ..mintermVariables = _mintermVariables
      ..mintermIndices = _mintermIndices
      ..maxtermVariables = _maxtermVariables
      ..maxtermIndices = _maxtermIndices
      ..termHeaders = _termHeaders;
  }
}
