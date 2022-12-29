import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';

import '../../../presets/preset_terms.dart';

void main() {
  test(
      "Given (A · B), when getting the minterms with headers A and B', then produces minterm 00, 10, 11 of (A · B')",
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
}
