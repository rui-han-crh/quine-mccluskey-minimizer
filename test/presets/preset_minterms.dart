import 'dart:collection';

import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/model/implicant.dart';

import 'preset_terms.dart';

Implicant abMintermZero = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.zero,
}));

Implicant abMintermOne = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.one,
}));

Implicant abMintermTwo = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.zero,
}));

Implicant abMintermThree = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.one,
}));

Implicant abcMintermZero = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.zero,
  termC: BinaryValue.zero
}));

Implicant abcMintermOne = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.zero,
  termC: BinaryValue.one
}));

Implicant abcMintermTwo = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.one,
  termC: BinaryValue.zero
}));

Implicant abcMintermThree = Implicant.create(LinkedHashMap.from(
    {termA: BinaryValue.zero, termB: BinaryValue.one, termC: BinaryValue.one}));

Implicant abcMintermFour = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.zero,
  termC: BinaryValue.zero
}));

Implicant abcMintermFive = Implicant.create(LinkedHashMap.from(
    {termA: BinaryValue.one, termB: BinaryValue.zero, termC: BinaryValue.one}));

Implicant abcMintermSix = Implicant.create(LinkedHashMap.from(
    {termA: BinaryValue.one, termB: BinaryValue.one, termC: BinaryValue.zero}));

Implicant abcMintermSeven = Implicant.create(LinkedHashMap.from(
    {termA: BinaryValue.one, termB: BinaryValue.one, termC: BinaryValue.one}));

Implicant abcdMintermZero = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.zero,
  termC: BinaryValue.zero,
  termD: BinaryValue.zero
}));

Implicant abcdMintermOne = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.zero,
  termC: BinaryValue.zero,
  termD: BinaryValue.one
}));

Implicant abcdMintermTwo = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.zero,
  termC: BinaryValue.one,
  termD: BinaryValue.zero
}));

Implicant abcdMintermThree = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.zero,
  termC: BinaryValue.one,
  termD: BinaryValue.one
}));

Implicant abcdMintermFour = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.one,
  termC: BinaryValue.zero,
  termD: BinaryValue.zero
}));

Implicant abcdMintermFive = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.one,
  termC: BinaryValue.zero,
  termD: BinaryValue.one
}));

Implicant abcdMintermSix = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.one,
  termC: BinaryValue.one,
  termD: BinaryValue.zero
}));

Implicant abcdMintermSeven = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.zero,
  termB: BinaryValue.one,
  termC: BinaryValue.one,
  termD: BinaryValue.one
}));

Implicant abcdMintermEight = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.zero,
  termC: BinaryValue.zero,
  termD: BinaryValue.zero
}));

Implicant abcdMintermNine = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.zero,
  termC: BinaryValue.zero,
  termD: BinaryValue.one
}));

Implicant abcdMintermTen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.zero,
  termC: BinaryValue.one,
  termD: BinaryValue.zero
}));

Implicant abcdMintermEleven = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.zero,
  termC: BinaryValue.one,
  termD: BinaryValue.one
}));

Implicant abcdMintermTwelve = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.one,
  termC: BinaryValue.zero,
  termD: BinaryValue.zero
}));

Implicant abcdMintermThirteen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.one,
  termC: BinaryValue.zero,
  termD: BinaryValue.one
}));

Implicant abcdMintermFourteen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.one,
  termC: BinaryValue.one,
  termD: BinaryValue.zero
}));

Implicant abcdMintermFifteen = Implicant.create(LinkedHashMap.from({
  termA: BinaryValue.one,
  termB: BinaryValue.one,
  termC: BinaryValue.one,
  termD: BinaryValue.one
}));
