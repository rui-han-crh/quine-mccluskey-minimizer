import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';

import '../../presets/preset_terms.dart';

void main() {
  test(
      "Given an answer generated from A · B · C · D + A' , when setting the headers to A, B, C, D, then retrieves minterm EPIs of (A · B · C · D) and (A')",
      () async {
    // ARRANGE
    Term terms = JoinedTerm(
        isConjunction: false,
        terms: [termA.conjunction(termB, termC, termD), termNotA]);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT
    List<String> headers = ["A", "B", "C", "D"];

    // ASSERT
    expect(answer.getMintermEssentialPrimeImplicants(headers), {
      Implicant.create({
        termA: BinaryValue.one,
        termB: BinaryValue.one,
        termC: BinaryValue.one,
        termD: BinaryValue.one
      }),
      Implicant.create({
        termA: BinaryValue.zero,
        termB: BinaryValue.dontCare,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.dontCare
      })
    });
  });

  test(
      "Given an answer generated from A · B · C · D + A' , when setting the headers to A, B, C, D, then retrieves max EPIs of (A + B + C + D) and (A')",
      () async {
    // ARRANGE
    Term terms = JoinedTerm(
        isConjunction: true,
        terms: [termA.disjunction(termB, termC, termD), termNotA]);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT
    List<String> headers = ["A", "B", "C", "D"];

    // ASSERT
    expect(answer.getMaxtermEssentialPrimeImplicants(headers), {
      Implicant.create({
        termA: BinaryValue.one,
        termB: BinaryValue.one,
        termC: BinaryValue.one,
        termD: BinaryValue.one
      }),
      Implicant.create({
        termA: BinaryValue.zero,
        termB: BinaryValue.dontCare,
        termC: BinaryValue.dontCare,
        termD: BinaryValue.dontCare
      })
    });
  });
}
