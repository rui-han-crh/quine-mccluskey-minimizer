import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';

import '../../../presets/preset_terms.dart';

void main() {
  test(
      "Given (A · B), when getting the minterms with headers A' and B, then produces minterm 1 of (A' · B)",
      () async {
    // Arrange
    JoinedTerm term = termA.conjunction(termB);

    // Act
    DisjunctiveNormalForm simplified =
        term.toDisjunctiveNormalForm().simplify();

    // Assert
    expect(
      simplified.getMinterms([termA.negate(), termB]),
      [
        Implicant.create({termNotA: BinaryValue.zero, termB: BinaryValue.one})
      ],
    );
  });
}
