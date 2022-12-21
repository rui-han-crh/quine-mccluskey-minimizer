import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/exceptions/key_not_found_exception.dart';
import 'package:proof_map/extensions/string_extension.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/utils/messages.dart';

import '../../presets/preset_terms.dart';

void main() {
  test(
      'Given an answer generated from A · B · C, when finding maxterms, '
      'then produces 001 to 111 of ABC ', () async {
    // ARRANGE
    Term terms = termA.conjunction(termB, termC);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT
    Iterable<Iterable<String>> mintermsABC =
        answer.maxtermTableValues(["A", "B", "C"]);

    // ASSERT
    expect(mintermsABC, [
      ["0", "0", "1"],
      ["0", "1", "0"],
      ["0", "1", "1"],
      ["1", "0", "0"],
      ["1", "0", "1"],
      ["1", "1", "0"],
      ["1", "1", "1"],
    ]);
  });

  test(
      'Given an answer generated from A · B · C, when finding minterms with ABCD, '
      'then throws a KeyNotFoundException as D does not exist in the answer ',
      () async {
    // ARRANGE
    Term terms = termA.conjunction(termB, termC);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT

    // ASSERT
    expect(
      () => answer.mintermTableValues(["A", "B", "C", "D"]),
      throwsA(KeyNotFoundException(
          keyDoesNotExistInMap.format(["D", "headerStringToTermsMap"]))),
    );
  });
}
