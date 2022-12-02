import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/binary_result.dart';
import 'package:proof_map/minterm.dart';

import 'util/preset_terms.dart';

void main() {
  test(
      "Given variables ABCD as minterm 1110, when constructing a minterm and retrieving the terms, then produces terms A, B, C and D'",
      () async {
    // Arrange

    // Act
    Minterm minterm = Minterm(LinkedHashMap.from({
      termA: BinaryResult.binaryTrue,
      termB: BinaryResult.binaryTrue,
      termC: BinaryResult.binaryTrue,
      termD: BinaryResult.binaryFalse
    }));

    // Assert
    expect(minterm.terms, [termA, termB, termC, termNotD]);
  });

  test(
      "Given variables ABCD as minterm 0000, when constructing a minterm and retrieving the terms, then produces terms A', B', C' and D'",
      () async {
    // Arrange

    // Act
    Minterm minterm = Minterm(LinkedHashMap.from({
      termA: BinaryResult.binaryFalse,
      termB: BinaryResult.binaryFalse,
      termC: BinaryResult.binaryFalse,
      termD: BinaryResult.binaryFalse
    }));

    // Assert
    expect(minterm.terms, [termNotA, termNotB, termNotC, termNotD]);
  });

  test(
      "Given variables A'B'C'D' as minterm 0100, when constructing a minterm and retrieving the terms, then produces terms A, B', C and D",
      () async {
    // Arrange

    // Act
    Minterm minterm = Minterm(LinkedHashMap.from({
      termNotA: BinaryResult.binaryFalse,
      termNotB: BinaryResult.binaryTrue,
      termNotC: BinaryResult.binaryFalse,
      termNotD: BinaryResult.binaryFalse
    }));

    // Assert
    expect(minterm.terms, [termA, termNotB, termC, termD]);
  });
}
