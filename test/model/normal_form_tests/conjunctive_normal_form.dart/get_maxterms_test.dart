import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';

import '../../../presets/preset_terms.dart';

void main() {
  test(
      "Given (A · B), when getting the minterms with headers A and B', then produces minterm 00, 01, 11 of (A · B')",
      () async {
    // Arrange
    JoinedTerm term = termA.conjunction(termB);

    // Act
    ConjunctiveNormalForm simplified =
        term.toConjunctiveNormalForm().simplify();

    // Assert
    expect(
      simplified.getMaxterms([termA, termB.negate()]),
      {
        Implicant.create({termA: BinaryValue.zero, termNotB: BinaryValue.zero}),
        Implicant.create({termA: BinaryValue.one, termNotB: BinaryValue.zero}),
        Implicant.create({termA: BinaryValue.one, termNotB: BinaryValue.one})
      },
    );
  });

  test(
      "Given (A + B) · (A + C) · (B + C), when getting the minterms with headers A and B and C, then produces minterm 0, 1, 2, 4",
      () async {
    // Arrange
    JoinedTerm term = JoinedTerm(isConjunction: true, terms: [
      termA.disjunction(termB),
      termA.disjunction(termC),
      termB.disjunction(termC)
    ]);

    // Act
    ConjunctiveNormalForm simplified =
        term.toConjunctiveNormalForm().simplify();

    // Assert
    expect(
      simplified.getMaxterms([termA, termB, termC]).map(
          (e) => e.maxtermBinaryRepresentation),
      {
        [BinaryValue.zero, BinaryValue.zero, BinaryValue.zero],
        [BinaryValue.zero, BinaryValue.zero, BinaryValue.one],
        [BinaryValue.zero, BinaryValue.one, BinaryValue.zero],
        [BinaryValue.one, BinaryValue.zero, BinaryValue.zero],
      },
    );
  });
}
