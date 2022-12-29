import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/model/term.dart';

import '../../../presets/preset_terms.dart';

void main() {
  test(
      'Given (A + B + C) * D, when simplified in CNF, then correctly produces JoinedTerm (A + B + C) * D',
      () async {
    // ARRANGE
    Term input = termA.disjunction(termB, termC).conjunction(termD);

    // ACT
    ConjunctiveNormalForm simplified =
        input.toConjunctiveNormalForm().simplify();

    // ASSERT
    expect(simplified.joinedTerm, input);
  });
}
