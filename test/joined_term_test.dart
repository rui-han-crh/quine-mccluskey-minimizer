import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/disjunctive_normal_form.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/model/variable.dart';
import 'util/preset_terms.dart' as terms;
import 'util/preset_variables.dart' as variables;

void main() {
  Variable a = variables.a;
  Variable notA = variables.notA;
  Variable b = variables.b;
  Variable notB = variables.notB;
  Variable c = variables.c;
  Variable notC = variables.notC;

  Term termA = terms.termA;
  Term termNotA = terms.termNotA;
  Term termB = terms.termB;
  Term termNotB = terms.termNotB;
  Term termC = terms.termC;
  Term termD = terms.termD;

  test(
      'Given a set of terms, when constructed namelessly with disjunction, then correctly constructs the joined term',
      () async {
    // Arrange

    // Act
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: false, terms: [termA, termB, termC]);

    // Assert
    expect(joinedTerm.statement, "A + B + C");
  });

  test(
      'Given a set of terms, when constructed namelessly with conjunction, then correctly constructs the joined term',
      () async {
    // Arrange

    // Act
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    // Assert
    expect(joinedTerm.statement, "A · B · C");
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
    expect(joinedTerm.statement, "A · B");
  });

  test(
      'Given a two independently constructed joined terms, when compared with ==, then assert them to be true if they have the same literals',
      () async {
    // Arrange
    JoinedTerm joinedTermOne =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    JoinedTerm joinedTermTwo =
        JoinedTerm(isConjunction: true, terms: [termA, termC, termB]);

    // Act

    // Assert
    expect(joinedTermOne, joinedTermTwo);
  });

  test(
      'Given a two independently constructed joined terms from independently constructed literals, when compared with ==, then assert them to be true if they have the same literals',
      () async {
    // Arrange
    JoinedTerm joinedTermOne =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    final termATwo = LiteralTerm(a, notA);
    final termBTwo = LiteralTerm(b, notB);
    final termCTwo = LiteralTerm(c, notC);
    JoinedTerm joinedTermTwo =
        JoinedTerm(isConjunction: true, terms: [termATwo, termCTwo, termBTwo]);

    // Act

    // Assert
    expect(joinedTermOne, joinedTermTwo);
  });

  test(
      'Given a joined term, when negated, then produces the correct negated statement',
      () async {
    // Arrange
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    // Act
    Term negatedTerm = joinedTerm.negate();

    // Assert
    expect(negatedTerm.statement, "A' + B' + C'");
  });

  test(
      'Given a joined term, when negated, then compares correctly to another independently created joined term of its negated form',
      () async {
    // Arrange
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termC, termB]);

    JoinedTerm negatedForm = JoinedTerm(
        isConjunction: false,
        terms: [termB.negate(), termC.negate(), termA.negate()]);

    // Act
    Term negatedTerm = joinedTerm.negate();

    // Assert
    expect(negatedTerm, negatedForm);
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
    expect(combined.statement, "A + (A · B · C)");
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
    expect(combined.statement, "A · (A + B + C)");
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
      "Given 1 and A, when joined with conjunction, then emulates identity law and produces A'",
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

  test("Given (A · (1 + B)), when joined with disjunction, then produces A'",
      () async {
    // Arrange

    // Act
    Term joinedTerm = termA.conjunction(LiteralTerm.one.disjunction(termB));

    // Assert
    expect(joinedTerm, JoinedTerm(isConjunction: true, terms: [termA]));
  });

  test(
      "Given A + B' + B + A' + C , when joined with disjunction, then emulates complement law and produces C",
      () async {
    // Arrange

    // Act
    Term joinedTerm = termA.disjunction(termNotB, termB, termNotA, termC);

    // Assert
    expect(joinedTerm, JoinedTerm(isConjunction: false, terms: [termC]));
  });

  test(
      "Given A + B' + B + C , when joined with disjunction, then emulates complement law and produces A + C",
      () async {
    // Arrange

    // Act
    Term joinedTerm = termA.disjunction(termNotB, termB, termC);

    // Assert
    expect(joinedTerm, JoinedTerm(isConjunction: false, terms: [termA, termC]));
  });

  test(
      'Given a (A · B) · (B + C), when converted to disjunctive normal form, then produces (A · B) + (A · B · C)',
      () async {
    // Arrange
    JoinedTerm left = JoinedTerm(isConjunction: true, terms: [termA, termB]);
    JoinedTerm right = JoinedTerm(isConjunction: false, terms: [termB, termC]);
    JoinedTerm together = JoinedTerm(isConjunction: true, terms: [left, right]);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm.statement, "(A · B) + (A · B · C)");
  });

  test(
      'Given a (A · B) · (B + C) · (C + A), when converted to disjunctive normal form, then produces (A · B · C) + (A · B)',
      () async {
    // Arrange
    JoinedTerm left = JoinedTerm(isConjunction: true, terms: [termA, termB]);
    JoinedTerm middle = JoinedTerm(isConjunction: false, terms: [termB, termC]);
    JoinedTerm right = JoinedTerm(isConjunction: false, terms: [termC, termA]);
    JoinedTerm together =
        JoinedTerm(isConjunction: true, terms: [left, middle, right]);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm.statement, "(A · B · C) + (A · B)");
  });

  test(
      "Given a (A · B') · (B + C) · (C + A), when converted to disjunctive normal form, then produces (A · B' · C)",
      () async {
    // Arrange
    JoinedTerm left = JoinedTerm(isConjunction: true, terms: [termA, termNotB]);
    JoinedTerm middle = JoinedTerm(isConjunction: false, terms: [termB, termC]);
    JoinedTerm right = JoinedTerm(isConjunction: false, terms: [termC, termA]);
    JoinedTerm together =
        JoinedTerm(isConjunction: true, terms: [left, middle, right]);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm.statement, "(A · B' · C)");
  });

  test(
      'Given a A + B + (C · D) + (D · C), when converted to disjunctive normal form, then produces A + B + (C · D)',
      () async {
    // Arrange
    JoinedTerm cAndD = termC.conjunction(termD);
    JoinedTerm dAndC = termD.conjunction(termC);
    JoinedTerm together = termA.disjunction(termB, cAndD, dAndC);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm,
        termA.disjunction(termB, termC.conjunction(termD)));
  });

  test(
      "Given a (A · B) + (A' · C) + (B · C), when converted to disjunctive normal form, then remains unchanged",
      () async {
    // Arrange
    JoinedTerm left = JoinedTerm(isConjunction: true, terms: [termA, termB]);
    JoinedTerm middle =
        JoinedTerm(isConjunction: true, terms: [termNotA, termC]);
    JoinedTerm right = JoinedTerm(isConjunction: true, terms: [termB, termC]);
    JoinedTerm together =
        JoinedTerm(isConjunction: false, terms: [left, middle, right]);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm.statement, "(A · B) + (A' · C) + (B · C)");
    expect(convertedTerm.joinedTerm, together);
  });

  test(
      "Given a (A · B) + (C · D), when converted to disjunctive normal form, then remains unchanged",
      () async {
    // Arrange
    JoinedTerm left = JoinedTerm(isConjunction: true, terms: [termA, termB]);
    JoinedTerm right = JoinedTerm(isConjunction: true, terms: [termC, termD]);
    JoinedTerm together =
        JoinedTerm(isConjunction: false, terms: [left, right]);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm.statement, "(A · B) + (C · D)");
    expect(
        convertedTerm.joinedTerm,
        JoinedTerm(isConjunction: false, terms: [
          JoinedTerm(isConjunction: true, terms: [termA, termB]),
          JoinedTerm(isConjunction: true, terms: [termC, termD])
        ]));
  });

  test(
      "Given a (A · B) + (B · (C + (A' · (D + C))) · (B' + D)), when converted to disjunctive normal form, then produces a disjunction of minterms (7), (5,7), (7, 15), (12-15)",
      () async {
    // Arrange
    JoinedTerm left = termA.conjunction(termB);
    JoinedTerm notBOrD = termNotB.disjunction(termD);
    JoinedTerm dOrC = termD.disjunction(termC);
    JoinedTerm notAAndDOrC = termNotA.conjunction(dOrC);
    JoinedTerm cOrNotAAndDOrC = termC.disjunction(notAAndDOrC);
    JoinedTerm right = termB.conjunction(cOrNotAAndDOrC, notBOrD);
    JoinedTerm together = left.disjunction(right);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    JoinedTerm minTermSeven = termB.conjunction(termNotA, termC, termD);
    JoinedTerm minTermFiveAndSeven = termB.conjunction(termD, termNotA);
    JoinedTerm minTermSevenAndFifteen = termB.conjunction(termC, termD);
    JoinedTerm minTermTwelveToFifteen = termA.conjunction(termB);
    JoinedTerm expected = minTermSeven.disjunction(
        minTermFiveAndSeven, minTermSevenAndFifteen, minTermTwelveToFifteen);
    expect(convertedTerm.joinedTerm, expected);
  });

  test(
      "Given (A · B) + (A' · C) + (B · C), when simplified, then produces (A · B) + (A' · C)",
      () async {
    // Arrange
    JoinedTerm left = JoinedTerm(isConjunction: true, terms: [termA, termB]);
    JoinedTerm middle =
        JoinedTerm(isConjunction: true, terms: [termNotA, termC]);
    JoinedTerm right = JoinedTerm(isConjunction: true, terms: [termB, termC]);
    JoinedTerm together =
        JoinedTerm(isConjunction: false, terms: [left, middle, right]);

    // Act
    JoinedTerm simplified = together.simplify();

    // Assert
    expect(simplified, JoinedTerm(isConjunction: false, terms: [left, middle]));
  });
}
