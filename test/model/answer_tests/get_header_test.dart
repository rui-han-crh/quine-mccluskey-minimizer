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
      'Given an answer generated from A · B · C, when setting the headers to A, B and C, '
      'then retreives the same headers A, B and C in terms', () async {
    // ARRANGE
    Term terms = termA.conjunction(termB, termC);
    Answer answer = Answer(
        disjunctiveNormalForm: terms.toDisjunctiveNormalForm(),
        conjunctiveNormalForm: terms.toConjunctiveNormalForm(),
        simplestForm: terms);

    // ACT
    List<String> headers = ["A", "B", "C"];
    answer = answer.withHeaders(headers);

    // ASSERT
    expect(
      answer.headers,
      [termA, termB, termC],
    );
  });
}
