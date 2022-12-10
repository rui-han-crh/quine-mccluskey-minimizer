import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/disjunctive_normal_form.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/term.dart';
import '../../presets/preset_terms.dart';
import '../../presets/preset_variables.dart';

void main() {
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
      'Given a (A + B + C) · D, when converted to disjunctive normal form, then produces (A · D) + (B · D) + (C · D)',
      () async {
    // Arrange
    JoinedTerm left =
        JoinedTerm(isConjunction: false, terms: [termA, termB, termC]);
    JoinedTerm together = JoinedTerm(isConjunction: true, terms: [left, termD]);

    // Act
    DisjunctiveNormalForm convertedTerm = together.toDisjunctiveNormalForm();

    // Assert
    expect(
        convertedTerm.joinedTerm,
        JoinedTerm(isConjunction: false, terms: [
          JoinedTerm(isConjunction: true, terms: [termA, termD]),
          JoinedTerm(isConjunction: true, terms: [termB, termD]),
          JoinedTerm(isConjunction: true, terms: [termC, termD]),
        ]));
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
      'Given a A + B + (C · D) + (D · C), when converted to disjunctive normal form, then the converted DNF has the joined terms written as A + B + (C · D)',
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
}
