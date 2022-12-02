import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/joined_term.dart';
import 'package:proof_map/literal_term.dart';
import 'package:proof_map/term.dart';
import 'package:proof_map/variable.dart';
import 'util/preset_terms.dart' as terms;
import 'util/preset_variables.dart' as variables;

void main() {
  Variable a = variables.a;
  Variable notA = variables.notA;
  Term termA = terms.termA;
  Term termB = terms.termB;
  Term termC = terms.termC;

  test(
      'Given positive statement, when constructed, then term also has correct negative statement',
      () async {
    // Arrange
    String naturalStatement = "A";
    String negativeStatement = "A'";
    final LiteralTerm term =
        LiteralTerm.fromStatements(naturalStatement, negativeStatement);

    // Act
    String observedNaturalStatement = term.statement;
    String observedNegativeStatement = term.negate().statement;

    // Assert
    expect(observedNaturalStatement, naturalStatement);
    expect(observedNegativeStatement, negativeStatement);
  });

  test(
      'Given a group of literals, when combined with conjunction, then is expressed correctly',
      () async {
    // Arrange

    // Act
    final JoinedTerm observedJoinedTerm = termA.conjunction(termB, termC);

    // Assert
    final JoinedTerm expectedTerm =
        JoinedTerm(isConjunction: true, terms: {termA, termB, termC});
    expect(observedJoinedTerm, expectedTerm);
  });

  test(
      'Given a group of literals, when combined with disjunction, then is expressed correctly',
      () async {
    // Arrange

    // Act
    final JoinedTerm observedJoinedTerm = termA.disjunction(termB, termC);

    // Assert
    final JoinedTerm expectedTerm =
        JoinedTerm(isConjunction: false, terms: {termA, termB, termC});
    expect(observedJoinedTerm, expectedTerm);
  });

  test(
      'Given a literal and the negation of itself, when combined with conjunction, then emulates the complement law and produces 0',
      () async {
    // Arrange
    LiteralTerm termNotA = LiteralTerm(notA, a);

    // Act
    final JoinedTerm observedJoinedTerm = termA.conjunction(termNotA);

    // Assert
    final JoinedTerm expectedTerm =
        JoinedTerm(isConjunction: true, terms: {LiteralTerm.zero});
    expect(observedJoinedTerm, expectedTerm);
  });

  test(
      'Given a literal and the negation of itself, when combined with disjunction, then emulates the inverse law and produces 1',
      () async {
    // Arrange
    LiteralTerm termNotA = LiteralTerm(notA, a);

    // Act
    final JoinedTerm observedJoinedTerm = termA.disjunction(termNotA);

    // Assert
    final JoinedTerm expectedTerm =
        JoinedTerm(isConjunction: false, terms: {LiteralTerm.one});
    expect(observedJoinedTerm, expectedTerm);
  });
}
