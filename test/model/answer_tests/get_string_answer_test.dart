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
      'Given an answer generated from A + B + C, when retrieving disjunctive statement, '
      'then produces "A + B + C"', () async {
    // ARRANGE
    JoinedTerm terms = termA.disjunction(termB, termC);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT
    String disjunctiveStatement = answer.disjunctiveNormalFormString;

    // ASSERT
    expect(disjunctiveStatement, "A + B + C");
  });

  test(
      'Given an answer generated from A · B · C, when retrieving disjunctive statement, '
      'then produces "A · B · C"', () async {
    // ARRANGE
    JoinedTerm terms = termA.conjunction(termB, termC);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT
    String disjunctiveStatement = answer.disjunctiveNormalFormString;

    // ASSERT
    expect(disjunctiveStatement, "A · B · C");
  });

  test(
      'Given an answer generated from B · C · A, when retrieving conjunctive statement, '
      'then produces "A · B · C"', () async {
    // ARRANGE
    JoinedTerm terms = termB.conjunction(termC, termA);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT
    String conjunctiveNormalForm = answer.conjuctiveNormalFormString;

    // ASSERT
    expect(conjunctiveNormalForm, "A · B · C");
  });
}
