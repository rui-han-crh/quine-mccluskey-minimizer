import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/model/variable.dart';

class LiteralTerm extends Term {
  // Describes the term using a variable
  final Variable _currentVariable;
  // Describes the negation of the variable
  final Variable _negatedVariable;

  static final LiteralTerm one =
      LiteralTerm(const Variable("1"), const Variable("0"));

  static final LiteralTerm zero = one.negate();

  Variable get currentVariable => _currentVariable;
  Variable get negatedVariable => _negatedVariable;

  @override
  Term simplify() {
    return this;
  }

  @override
  List<Object?> get props => [_currentVariable, _negatedVariable];

  @override
  LiteralTerm negate() => LiteralTerm(_negatedVariable, _currentVariable);

  LiteralTerm.fromStatements(String positiveStatement, String negatedStatement)
      : _currentVariable = Variable(positiveStatement),
        _negatedVariable = Variable(negatedStatement);

  LiteralTerm.fromStatement(String postulate)
      : _currentVariable = Variable(postulate),
        _negatedVariable = Variable("$postulate'");

  LiteralTerm(this._currentVariable, this._negatedVariable);

  // Describes this term as a statement
  @override
  String get postulate => _currentVariable.statement;

  /// Returns a string representation of this term
  @override
  String toString() {
    return _currentVariable.statement;
  }

  @override
  ConjunctiveNormalForm toConjunctiveNormalForm() {
    return _ConjunctiveNormalForm(this);
  }

  @override
  DisjunctiveNormalForm toDisjunctiveNormalForm() {
    return _DisjunctiveNormalForm(this);
  }

  @override
  Iterable<LiteralTerm> getUniqueTerms() {
    return [this];
  }
}

class _ConjunctiveNormalForm extends ConjunctiveNormalForm {
  LiteralTerm term;
  @override
  JoinedTerm get joinedTerm => JoinedTerm(isConjunction: false, terms: [term]);

  _ConjunctiveNormalForm(this.term);
}

class _DisjunctiveNormalForm extends DisjunctiveNormalForm {
  LiteralTerm term;
  @override
  JoinedTerm get joinedTerm => JoinedTerm(isConjunction: false, terms: [term]);

  _DisjunctiveNormalForm(this.term);
}
