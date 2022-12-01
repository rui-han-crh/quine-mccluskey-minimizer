import 'package:proof_map/term.dart';
import 'package:proof_map/variable.dart';

class LiteralTerm extends Term {
  // Describes the term using a variable
  final Variable _currentVariable;
  // Describes the negation of the variable
  final Variable _negatedVariable;

  static final LiteralTerm one =
      LiteralTerm(const Variable("1"), const Variable("0"));

  static final LiteralTerm zero = one.negate() as LiteralTerm;

  Variable get currentVariable => _currentVariable;
  Variable get negatedVariable => _negatedVariable;

  @override
  List<Object?> get props => [_currentVariable, _negatedVariable];

  @override
  Term negate() => LiteralTerm(_negatedVariable, _currentVariable);

  LiteralTerm.fromStatements(String positiveStatement, String negatedStatement)
      : _currentVariable = Variable(positiveStatement),
        _negatedVariable = Variable(negatedStatement);

  LiteralTerm(this._currentVariable, this._negatedVariable);

  // Describes this term as a statement
  @override
  String get statement => _currentVariable.statement;

  /// Returns a string representation of this term
  @override
  String toString() {
    return _currentVariable.statement;
  }
}
