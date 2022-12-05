import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/utils/boolean_algebra/binary_result.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/prime_implicant.dart';
import 'package:proof_map/utils/boolean_algebra/quine_mccluskey.dart'
    as quine_mccluskey;

import 'util/preset_terms.dart';

void main() {
  test(
      "Given A'·B'·C, B·C'·D, A'·B·C', A·B'·D', A'·C·D, B·D, when computed with Quine-McCluskey, then produces the essential prime implicants A'·B'·C + A'·B·C' + A·B'·D' + B·D",
      () async {
    // ARRANGE
    PrimeImplicant notANotBC = Implicant.create({
      termA: BinaryValue.binaryZero, // 0
      termB: BinaryValue.binaryZero, // 0
      termC: BinaryValue.binaryOne, // 1
      termD: BinaryValue.redundant // -
    }) as PrimeImplicant;

    PrimeImplicant bNotCD = Implicant.create({
      termA: BinaryValue.redundant, // -
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.binaryZero, // 0
      termD: BinaryValue.binaryOne // 1
    }) as PrimeImplicant;

    PrimeImplicant notABNotC = Implicant.create({
      termA: BinaryValue.binaryZero, // 0
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.binaryZero, // 0
      termD: BinaryValue.redundant // -
    }) as PrimeImplicant;

    PrimeImplicant aNotBNotD = Implicant.create({
      termA: BinaryValue.binaryOne, // 1
      termB: BinaryValue.binaryZero, // 0
      termC: BinaryValue.redundant, // -
      termD: BinaryValue.binaryZero // 0
    }) as PrimeImplicant;

    PrimeImplicant notACD = Implicant.create({
      termA: BinaryValue.binaryZero, // 0
      termB: BinaryValue.redundant, // -
      termC: BinaryValue.binaryOne, // 1
      termD: BinaryValue.binaryOne // 1
    }) as PrimeImplicant;

    PrimeImplicant bD = Implicant.create({
      termA: BinaryValue.redundant, // -
      termB: BinaryValue.binaryOne, // 1
      termC: BinaryValue.redundant, // -
      termD: BinaryValue.binaryOne // 1
    }) as PrimeImplicant;

    // ACT
    Iterable<Implicant> result = quine_mccluskey
        .compute([notANotBC, bNotCD, notABNotC, aNotBNotD, notACD, bD]);
    // ASSERT
    expect(result.toSet(), {notANotBC, notABNotC, aNotBNotD, bD});
  });
}
