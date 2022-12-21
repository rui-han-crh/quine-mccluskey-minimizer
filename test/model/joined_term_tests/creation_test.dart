import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/term.dart';
import '../../presets/preset_terms.dart';
import '../../presets/preset_variables.dart';

void main() {
  test(
      'Given a set of terms A, B and C, when constructed namelessly with disjunction, then correctly constructs the joined term (A + B + C)',
      () async {
    // Arrange

    // Act
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: false, terms: [termA, termB, termC]);

    // Assert
    expect(joinedTerm.postulate, "A + B + C");
  });

  test(
      'Given terms A, B and C, when constructed namelessly with conjunction, then correctly constructs the joined term (A · B · C)',
      () async {
    // Arrange

    // Act
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    // Assert
    expect(joinedTerm.postulate, "A · B · C");
  });

  test(
      'Given two A terms and one B term, when constructed namelessly with conjunction, then correctly constructs A · B',
      () async {
    // Arrange
    Term anotherTermA = LiteralTerm(a, notA);

    // Act
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, anotherTermA, termB]);

    // Assert
    expect(joinedTerm.postulate, "A · B");
  });

  test(
      'Given a A and (A · B · C), when joined with conjunction, then creates a nested joined term A + (A · B · C)',
      () async {
    // Arrange
    LiteralTerm literalTerm = LiteralTerm(a, notA);
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    // Act
    Term combined = joinedTerm.disjunction(literalTerm);

    // Assert
    expect(combined.postulate, "A + (A · B · C)");
  });

  test(
      'Given a A and (A + B + C), when joined with conjunction, then creates a nested joined term A · (A + B + C)',
      () async {
    // Arrange
    LiteralTerm literalTerm = LiteralTerm(a, notA);
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: false, terms: [termA, termB, termC]);

    // Act
    Term combined = joinedTerm.conjunction(literalTerm);

    // Assert
    expect(combined.postulate, "A · (A + B + C)");
  });

  test(
      "Given A and A', when joined with conjunction, then emulates complement law and produces 0",
      () async {
    // Arrange
    LiteralTerm literalTerm = LiteralTerm(a, notA);
    Term negatedTerm = literalTerm.negate();

    // Act
    Term joinedTerm = literalTerm.conjunction(negatedTerm);

    // Assert
    expect(
        joinedTerm, JoinedTerm(isConjunction: true, terms: [LiteralTerm.zero]));
  });

  test(
      "Given A · B' · B · A' · C , when joined with conjunction, then emulates complement law and produces 0",
      () async {
    // Arrange

    // Act
    Term joinedTerm = termA.conjunction(termNotB, termB, termNotA, termC);

    // Assert
    expect(
        joinedTerm, JoinedTerm(isConjunction: true, terms: [LiteralTerm.zero]));
  });

  test(
      "Given 1 and A, when joined with conjunction, then emulates identity law and produces A",
      () async {
    // Arrange

    // Act
    Term joinedTerm = LiteralTerm.one.conjunction(termA);

    // Assert
    expect(joinedTerm, JoinedTerm(isConjunction: true, terms: [termA]));
  });

  test(
      "Given 0 and A, when joined with conjunction, then emulates zero element theorem and produces 0",
      () async {
    // Arrange

    // Act
    Term joinedTerm = LiteralTerm.zero.conjunction(termA);

    // Assert
    expect(
        joinedTerm, JoinedTerm(isConjunction: true, terms: [LiteralTerm.zero]));
  });

  test(
      "Given A and A', when joined with disjunction, then emulates inverse law and produces 1",
      () async {
    // Arrange
    LiteralTerm literalTerm = LiteralTerm(a, notA);
    Term negatedTerm = literalTerm.negate();

    // Act
    Term joinedTerm = literalTerm.disjunction(negatedTerm);

    // Assert
    expect(
        joinedTerm, JoinedTerm(isConjunction: false, terms: [LiteralTerm.one]));
  });

  test(
      "Given 0 and A', when joined with disjunction, then emulates inverse law and produces A'",
      () async {
    // Arrange

    // Act
    Term joinedTerm = LiteralTerm.zero.disjunction(termNotA);

    // Assert
    expect(joinedTerm, JoinedTerm(isConjunction: false, terms: [termNotA]));
  });

  test(
      "Given (A + A' + B), when joined with disjunction, then emulates one element and produces 1",
      () async {
    // Arrange

    // Act
    Term joinedTerm = termA.disjunction(termNotA, termB);

    // Assert
    expect(
        joinedTerm, JoinedTerm(isConjunction: false, terms: [LiteralTerm.one]));
  });

  test("Given (A · (1 + B)), when joined with disjunction, then produces A'",
      () async {
    // Arrange

    // Act
    Term joinedTerm = termA.conjunction(LiteralTerm.one.disjunction(termB));

    // Assert
    expect(joinedTerm, JoinedTerm(isConjunction: true, terms: [termA]));
  });

  test(
      "Given A + B' + B + A' + C , when joined with disjunction, then emulates complement law and produces 1",
      () async {
    // Arrange

    // Act
    Term joinedTerm = termA.disjunction(termNotB, termB, termNotA, termC);

    // Assert
    expect(
        joinedTerm, JoinedTerm(isConjunction: false, terms: [LiteralTerm.one]));
  });
}
