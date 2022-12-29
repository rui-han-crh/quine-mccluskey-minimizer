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
      termA: BinaryValue.one,
      termB: BinaryValue.one,
      termC: BinaryValue.one,
      termD: BinaryValue.zero
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
      termA: BinaryValue.zero,
      termB: BinaryValue.zero,
      termC: BinaryValue.zero,
      termD: BinaryValue.zero
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
      termNotA: BinaryValue.zero,
      termNotB: BinaryValue.one,
      termNotC: BinaryValue.zero,
      termNotD: BinaryValue.zero
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
      termA: BinaryValue.dontCare,
      termB: BinaryValue.dontCare,
      termC: BinaryValue.dontCare,
      termNotD: BinaryValue.dontCare,
      termE: BinaryValue.one,
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
      termA: BinaryValue.dontCare,
      termB: BinaryValue.dontCare,
    }));

    // Assert
    expect(minterm.terms, [LiteralTerm.one]);
  });
}
