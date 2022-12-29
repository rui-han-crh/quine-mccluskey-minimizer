import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/utils/boolean_algebra/quine_mccluskey.dart'
    as quine_mccluskey;

import '../presets/preset_minterms.dart';
import '../presets/preset_terms.dart';

void main() {
  test(
      // testbook test case
      "Given minterms of ABCD 2, 3, 4, 5, 7, 8, 10, 13, 15 when computed with Quine-McCluskey, then produces the essential prime implicants (B · D) + (A' · B · C') + (A · B' · D') + (A' · B' · C)",
      () async {
    // ARRANGE

    // ACT
    Iterable<Implicant> result = quine_mccluskey.compute([
      abcdMintermTwo,
      abcdMintermThree,
      abcdMintermFour,
      abcdMintermFive,
      abcdMintermSeven,
      abcdMintermEight,
      abcdMintermTen,
      abcdMintermThirteen,
      abcdMintermFifteen
    ]);

    // ASSERT
    expect(result.toSet(), {
      Implicant.create({
        termA: BinaryValue.dontCare,
        termB: BinaryValue.one,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.one
      }),
      Implicant.create({
        termA: BinaryValue.zero,
        termB: BinaryValue.one,
        termC: BinaryValue.zero,
        termD: BinaryValue.dontCare
      }),
      Implicant.create({
        termA: BinaryValue.one,
        termB: BinaryValue.zero,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.zero
      }),
      Implicant.create({
        termA: BinaryValue.zero,
        termB: BinaryValue.zero,
        termC: BinaryValue.one,
        termD: BinaryValue.dontCare
      })
    });
  });

  test(
      "Given A'·B'·C, B·C'·D, A'·B·C', A·B'·D', A'·C·D, B·D, when computed with Quine-McCluskey, then produces the essential prime implicants A'·B'·C + A'·B·C' + A·B'·D' + B·D",
      () async {
    // ARRANGE
    Implicant notANotBC = Implicant.create({
      termA: BinaryValue.zero, // 0
      termB: BinaryValue.zero, // 0
      termC: BinaryValue.one, // 1
      termD: BinaryValue.dontCare // -
    });

    Implicant bNotCD = Implicant.create({
      termA: BinaryValue.dontCare, // -
      termB: BinaryValue.one, // 1
      termC: BinaryValue.zero, // 0
      termD: BinaryValue.one // 1
    });

    Implicant notABNotC = Implicant.create({
      termA: BinaryValue.zero, // 0
      termB: BinaryValue.one, // 1
      termC: BinaryValue.zero, // 0
      termD: BinaryValue.dontCare // -
    });

    Implicant aNotBNotD = Implicant.create({
      termA: BinaryValue.one, // 1
      termB: BinaryValue.zero, // 0
      termC: BinaryValue.dontCare, // -
      termD: BinaryValue.zero // 0
    });

    Implicant notACD = Implicant.create({
      termA: BinaryValue.zero, // 0
      termB: BinaryValue.dontCare, // -
      termC: BinaryValue.one, // 1
      termD: BinaryValue.one // 1
    });

    Implicant bD = Implicant.create({
      termA: BinaryValue.dontCare, // -
      termB: BinaryValue.one, // 1
      termC: BinaryValue.dontCare, // -
      termD: BinaryValue.one // 1
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
      termA: BinaryValue.one, // 1
      termB: BinaryValue.one, // 1
      termC: BinaryValue.dontCare, // -
    });

    Implicant notAC = Implicant.create({
      termA: BinaryValue.zero, // 0
      termB: BinaryValue.dontCare, // -
      termC: BinaryValue.one, // 1
    });

    Implicant bC = Implicant.create({
      termA: BinaryValue.dontCare, // 0
      termB: BinaryValue.one, // 1
      termC: BinaryValue.one, // 1
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
      termA: BinaryValue.one, // 1
      termB: BinaryValue.one, // 1
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
        termA: BinaryValue.one,
        termB: BinaryValue.dontCare,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.one
      }),
      Implicant.create({
        termA: BinaryValue.dontCare,
        termB: BinaryValue.one,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.one
      }),
      Implicant.create({
        termA: BinaryValue.dontCare,
        termB: BinaryValue.dontCare,
        termC: BinaryValue.one,
        termD: BinaryValue.one
      })
    });
  });

  test(
      "Given (A' · B) + (A · B') + (A · B), when computed with Quine-McCluskey, then produces the essential prime implicants (A) + (B)",
      () async {
    // ARRANGE
    Implicant notAB = Implicant.create({
      termA: BinaryValue.zero, // 0
      termB: BinaryValue.one, // 1
    });

    Implicant aNotB = Implicant.create({
      termA: BinaryValue.one, // 1
      termB: BinaryValue.zero, // 0
    });

    Implicant aB = Implicant.create({
      termA: BinaryValue.one, // 1
      termB: BinaryValue.one, // 1
    });

    // ACT
    Iterable<Implicant> result = quine_mccluskey.compute([notAB, aNotB, aB]);
    // ASSERT
    expect(result.toSet(), {
      Implicant.create({termA: BinaryValue.one, termB: BinaryValue.dontCare}),
      Implicant.create({termA: BinaryValue.dontCare, termB: BinaryValue.one})
    });
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
        termA: BinaryValue.one,
        termB: BinaryValue.dontCare,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.one
      }),
      Implicant.create({
        termA: BinaryValue.dontCare,
        termB: BinaryValue.one,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.one
      }),
      Implicant.create({
        termA: BinaryValue.dontCare,
        termB: BinaryValue.dontCare,
        termC: BinaryValue.one,
        termD: BinaryValue.one
      })
    });
  });
}
