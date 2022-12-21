import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/model/joined_term.dart';
import '../../presets/preset_terms.dart';

void main() {
  test(
      'Given a (A · B) + (B · C), when converted to conjunctive normal form,'
      'then produces (A + B) · (A + C) · B · (B + C)', () async {
    // Arrange
    JoinedTerm left = JoinedTerm(isConjunction: true, terms: [termA, termB]);
    JoinedTerm right = JoinedTerm(isConjunction: true, terms: [termB, termC]);
    JoinedTerm together =
        JoinedTerm(isConjunction: false, terms: [left, right]);

    // Act
    ConjunctiveNormalForm convertedTerm = together.toConjunctiveNormalForm();

    // Assert
    expect(
        convertedTerm.joinedTerm,
        JoinedTerm(isConjunction: true, terms: [
          termA.disjunction(termB),
          termA.disjunction(termC),
          termB,
          termB.disjunction(termC)
        ]));
  });

  test(
      'Given a A + B, when converted to conjunctive normal form,'
      'then produces (A + B)', () async {
    // Arrange
    JoinedTerm term = JoinedTerm(isConjunction: false, terms: [termA, termB]);

    // Act
    ConjunctiveNormalForm convertedTerm = term.toConjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm, termA.disjunction(termB));
  });

  test(
      'Given a A · B, when converted to conjunctive normal form,'
      'then produces A · B', () async {
    // Arrange
    JoinedTerm term = JoinedTerm(isConjunction: true, terms: [termA, termB]);

    // Act
    ConjunctiveNormalForm convertedTerm = term.toConjunctiveNormalForm();

    // Assert
    expect(convertedTerm.joinedTerm, termA.conjunction(termB));
  });

  test(
      'Given a (A · B) + C, when converted to conjunctive normal form,'
      'then produces (A + C) · (B + C)', () async {
    // Arrange
    JoinedTerm term = JoinedTerm(
        isConjunction: false, terms: [termA.conjunction(termB), termC]);

    // Act
    ConjunctiveNormalForm convertedTerm = term.toConjunctiveNormalForm();

    // Assert
    expect(
      convertedTerm.joinedTerm,
      JoinedTerm(
        isConjunction: true,
        terms: [termA.disjunction(termC), termB.disjunction(termC)],
      ),
    );
  });

  test(
      "Given a (A · B) + (B' · C) + D + (A · C · D), when converted to conjunctive normal form, then produces a disjunction of minterms ",
      () async {
    // Arrange
    JoinedTerm together = JoinedTerm(isConjunction: false, terms: [
      termA.conjunction(termB),
      termNotB.conjunction(termC),
      termD,
      termA.conjunction(termC, termD)
    ]);

    // Act
    ConjunctiveNormalForm convertedTerm = together.toConjunctiveNormalForm();

    // Assert
    expect(
      convertedTerm.joinedTerm,
      JoinedTerm(isConjunction: true, terms: [
        termA.disjunction(termNotB, termD),
        termA.disjunction(termNotB, termD, termC),
        termA.disjunction(termB, termD, termC),
        termA.disjunction(termC, termD),
        termB.disjunction(termC, termD)
      ]),
    );
  });
}
