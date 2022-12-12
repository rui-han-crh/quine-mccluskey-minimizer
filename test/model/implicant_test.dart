import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/model/implicant.dart';

import '../presets/preset_terms.dart';

void main() {
  test(
      "Given variables ABCD as minterm 1110, when constructing a minterm and retrieving the terms, then produces terms A, B, C and D'",
      () async {
    // Arrange

    // Act
    Implicant minterm = Implicant.create(LinkedHashMap.from({
      termA: BinaryValue.binaryOne,
      termB: BinaryValue.binaryOne,
      termC: BinaryValue.binaryOne,
      termD: BinaryValue.binaryZero
    }));

    // Assert
    expect(minterm.terms, [termA, termB, termC, termNotD]);
  });

  test(
      "Given variables ABCD as minterm 0000, when constructing a minterm and retrieving the terms, then produces terms A', B', C' and D'",
      () async {
    // Arrange

    // Act
    Implicant minterm = Implicant.create(LinkedHashMap.from({
      termA: BinaryValue.binaryZero,
      termB: BinaryValue.binaryZero,
      termC: BinaryValue.binaryZero,
      termD: BinaryValue.binaryZero
    }));

    // Assert
    expect(minterm.terms, [termNotA, termNotB, termNotC, termNotD]);
  });

  test(
      "Given variables A'B'C'D' as minterm 0100, when constructing a minterm and retrieving the terms, then produces terms A, B', C and D",
      () async {
    // Arrange

    // Act
    Implicant minterm = Implicant.create(LinkedHashMap.from({
      termNotA: BinaryValue.binaryZero,
      termNotB: BinaryValue.binaryOne,
      termNotC: BinaryValue.binaryZero,
      termNotD: BinaryValue.binaryZero
    }));

    // Assert
    expect(minterm.terms, [termA, termNotB, termC, termD]);
  });

  test(
      "Given variables ABCD'E as -----, when constructed and retrieving the terms, then produces terms A, B', C and D",
      () async {
    // Arrange

    // Act
    Implicant minterm = Implicant.create(LinkedHashMap.from({
      termA: BinaryValue.redundant,
      termB: BinaryValue.redundant,
      termC: BinaryValue.redundant,
      termNotD: BinaryValue.redundant,
      termE: BinaryValue.binaryOne,
    }));

    // Assert
    expect(minterm.terms, [termE]);
  });

  test(
      "Given variables AB --, when constructed and retrieving the terms, then produces terms 1",
      () async {
    // Arrange

    // Act
    Implicant minterm = Implicant.create(LinkedHashMap.from({
      termA: BinaryValue.redundant,
      termB: BinaryValue.redundant,
    }));

    // Assert
    expect(minterm.terms, LiteralTerm.one);
  });
}
