import 'dart:collection';

import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/model/implicant.dart';

import 'preset_terms.dart';

Implicant abMintermZero = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryZero,
}));

Implicant abMintermOne = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryOne,
}));

Implicant abMintermTwo = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryZero,
}));

Implicant abMintermThree = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryOne,
}));

Implicant abcMintermZero = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryZero
}));

Implicant abcMintermOne = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryOne
}));

Implicant abcMintermTwo = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryZero
}));

Implicant abcMintermThree = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryOne
}));

Implicant abcMintermFour = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryZero
}));

Implicant abcMintermFive = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryOne
}));

Implicant abcMintermSix = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryZero
}));

Implicant abcMintermSeven = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryOne
}));

Implicant abcdMintermZero = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermOne = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryOne
}));

Implicant abcdMintermTwo = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermThree = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryOne
}));

Implicant abcdMintermFour = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermFive = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryOne
}));

Implicant abcdMintermSix = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermSeven = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryZero,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryOne
}));

Implicant abcdMintermEight = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermNine = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryOne
}));

Implicant abcdMintermTen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermEleven = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryZero,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryOne
}));

Implicant abcdMintermTwelve = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermThirteen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryZero,
  termD: BinaryValue.binaryOne
}));

Implicant abcdMintermFourteen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryZero
}));

Implicant abcdMintermFifteen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.binaryOne,
  termB: BinaryValue.binaryOne,
  termC: BinaryValue.binaryOne,
  termD: BinaryValue.binaryOne
}));
