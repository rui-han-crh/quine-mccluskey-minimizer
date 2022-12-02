import 'dart:collection';

import 'package:proof_map/binary_result.dart';
import 'package:proof_map/minterm.dart';

import 'preset_terms.dart';

Minterm abMintermZero = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryFalse,
}));

Minterm abMintermOne = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryTrue,
}));

Minterm abMintermTwo = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryFalse,
}));

Minterm abMintermThree = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryTrue,
}));

Minterm abcMintermZero = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryFalse
}));

Minterm abcMintermOne = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryTrue
}));

Minterm abcMintermTwo = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryFalse
}));

Minterm abcMintermThree = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryTrue
}));

Minterm abcMintermFour = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryFalse
}));

Minterm abcMintermFive = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryTrue
}));

Minterm abcMintermSix = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryFalse
}));

Minterm abcMintermSeven = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryTrue
}));

Minterm abcdMintermZero = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermOne = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryTrue
}));

Minterm abcdMintermTwo = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermThree = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryTrue
}));

Minterm abcdMintermFour = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermFive = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryTrue
}));

Minterm abcdMintermSix = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermSeven = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryFalse,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryTrue
}));

Minterm abcdMintermEight = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermNine = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryTrue
}));

Minterm abcdMintermTen = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermEleven = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryFalse,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryTrue
}));

Minterm abcdMintermTwelve = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermThirteen = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryFalse,
  termD: BinaryResult.binaryTrue
}));

Minterm abcdMintermFourteen = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryFalse
}));

Minterm abcdMintermFifteen = Minterm(LinkedHashMap.from({
  termA: BinaryResult.binaryTrue,
  termB: BinaryResult.binaryTrue,
  termC: BinaryResult.binaryTrue,
  termD: BinaryResult.binaryTrue
}));
