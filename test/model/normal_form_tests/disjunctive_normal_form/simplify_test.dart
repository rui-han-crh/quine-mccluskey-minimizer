import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/model/term.dart';

import '../../../presets/preset_terms.dart';

void main() {
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
    DisjunctiveNormalForm simplified =
        together.toDisjunctiveNormalForm().simplify();

    // Assert
    expect(simplified.joinedTerm,
        JoinedTerm(isConjunction: false, terms: [left, middle]));
  });

  test("Given (A · B), when simplified, then produces (A · B)", () async {
    // Arrange
    JoinedTerm term = termA.conjunction(termB);

    // Act
    DisjunctiveNormalForm simplified =
        term.toDisjunctiveNormalForm().simplify();

    // Assert
    expect(simplified.joinedTerm, term);
  });

  test("Given (A + B), when simplified, then produces (A + B)", () async {
    // Arrange
    JoinedTerm term = termA.disjunction(termB);

    // Act
    DisjunctiveNormalForm simplified =
        term.toDisjunctiveNormalForm().simplify();

    // Assert
    expect(simplified.joinedTerm, term);
  });

  test("Given A, when simplified, then produces A", () async {
    // Arrange

    // Act
    DisjunctiveNormalForm simplified =
        termA.toDisjunctiveNormalForm().simplify();

    // Assert
    expect(simplified.joinedTerm,
        JoinedTerm(isConjunction: false, terms: [termA]));
  });

  test(
      'Given (A + B + C) * D, when simplified, then correctly produces JoinedTerm (A · D) + (B · D) + (C · D)',
      () async {
    // ARRANGE
    Term input = termA.disjunction(termB, termC).conjunction(termD);

    // ACT
    DisjunctiveNormalForm simplified =
        input.toDisjunctiveNormalForm().simplify();

    // ASSERT
    expect(
        simplified.joinedTerm,
        JoinedTerm(isConjunction: false, terms: [
          JoinedTerm(isConjunction: true, terms: [termA, termD]),
          JoinedTerm(isConjunction: true, terms: [termB, termD]),
          JoinedTerm(isConjunction: true, terms: [termC, termD]),
        ]));
  });

  test(
      'Given A + B + C + D, when simplified, then correctly produces JoinedTerm A + B + C + D',
      () async {
    // ARRANGE
    Term input = termA.disjunction(termB, termC, termD);

    // ACT
    DisjunctiveNormalForm simplified =
        input.toDisjunctiveNormalForm().simplify();

    // ASSERT
    expect(simplified.joinedTerm,
        JoinedTerm(isConjunction: false, terms: [termA, termB, termC, termD]));
  });
}
