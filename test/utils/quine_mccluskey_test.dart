import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/utils/boolean_algebra/quine_mccluskey.dart'
    as quine_mccluskey;

import '../presets/preset_minterms.dart';
import '../presets/preset_terms.dart';

void main() {
  test(
      "Given A'·B'·C, B·C'·D, A'·B·C', A·B'·D', A'·C·D, B·D, when computed with Quine-McCluskey, then produces the essential prime implicants A'·B'·C + A'·B·C' + A·B'·D' + B·D",
      () async {
    // ARRANGE
    Implicant notANotBC = Implicant.create({
      termA: BinaryValue.binaryZero, // 0
      termB: BinaryValue.binaryZero, // 0
      termC: BinaryValue.binaryOne, // 1
      termD: BinaryValue.redundant // -
    });

    Implicant bNotCD = Implicant.create({
      termA: BinaryValue.redundant, // -
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.binaryZero, // 0
      termD: BinaryValue.binaryOne // 1
    });

    Implicant notABNotC = Implicant.create({
      termA: BinaryValue.binaryZero, // 0
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.binaryZero, // 0
      termD: BinaryValue.redundant // -
    });

    Implicant aNotBNotD = Implicant.create({
      termA: BinaryValue.binaryOne, // 1
      termB: BinaryValue.binaryZero, // 0
      termC: BinaryValue.redundant, // -
      termD: BinaryValue.binaryZero // 0
    });

    Implicant notACD = Implicant.create({
      termA: BinaryValue.binaryZero, // 0
      termB: BinaryValue.redundant, // -
      termC: BinaryValue.binaryOne, // 1
      termD: BinaryValue.binaryOne // 1
    });

    Implicant bD = Implicant.create({
      termA: BinaryValue.redundant, // -
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.redundant, // -
      termD: BinaryValue.binaryOne // 1
    });

    // ACT
    Iterable<Implicant> result = quine_mccluskey
        .compute([notANotBC, bNotCD, notABNotC, aNotBNotD, notACD, bD]);

    // ASSERT
    expect(result.toSet(), {notANotBC, notABNotC, aNotBNotD, bD});
  });

  test(
      "Given A · B + A' · C + B · C, when computed with Quine-McCluskey, then produces the essential prime implicants A · B + A' · C",
      () async {
    // ARRANGE
    Implicant aB = Implicant.create({
      termA: BinaryValue.binaryOne, // 1
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.redundant, // -
    });

    Implicant notAC = Implicant.create({
      termA: BinaryValue.binaryZero, // 0
      termB: BinaryValue.redundant, // -
      termC: BinaryValue.binaryOne, // 1
    });

    Implicant bC = Implicant.create({
      termA: BinaryValue.redundant, // 0
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.binaryOne, // 1
    });

    // ACT
    Iterable<Implicant> result = quine_mccluskey.compute([aB, notAC, bC]);
    // ASSERT
    expect(result.toSet(), {aB, notAC});
  });

  test(
      "Given A · B, when computed with Quine-McCluskey, then produces the essential prime implicants A · B",
      () async {
    // ARRANGE
    Implicant aB = Implicant.create({
      termA: BinaryValue.binaryOne, // 1
      termB: BinaryValue.binaryOne, // 1
    });

    // ACT
    Iterable<Implicant> result = quine_mccluskey.compute([aB]);
    // ASSERT
    expect(result.toSet(), {aB});
  });

  test(
      "Given minterms of ABCD 3, 5, 7, 9, 11, 13, 15 when computed with Quine-McCluskey, then produces the essential prime implicants A · B",
      () async {
    // ARRANGE

    // ACT
    Iterable<Implicant> result = quine_mccluskey.compute([
      abcdMintermThree,
      abcdMintermFive,
      abcdMintermSeven,
      abcdMintermNine,
      abcdMintermEleven,
      abcdMintermThirteen,
      abcdMintermFifteen
    ]);

    // ASSERT
    expect(result.toSet(), {
      Implicant.create({
        termA: BinaryValue.binaryOne,
        termB: BinaryValue.redundant,
        termC: BinaryValue.redundant,
        termD: BinaryValue.binaryOne
      }),
      Implicant.create({
        termA: BinaryValue.redundant,
        termB: BinaryValue.binaryOne,
        termC: BinaryValue.redundant,
        termD: BinaryValue.binaryOne
      }),
      Implicant.create({
        termA: BinaryValue.redundant,
        termB: BinaryValue.redundant,
        termC: BinaryValue.binaryOne,
        termD: BinaryValue.binaryOne
      })
    });
  });
}
