import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import '../../presets/preset_terms.dart';
import '../../presets/preset_variables.dart';

void main() {
  test(
      'Given a two independently constructed joined terms, when compared with ==, then assert them to be true if they have the same literals',
      () async {
    // Arrange
    JoinedTerm joinedTermOne =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    JoinedTerm joinedTermTwo =
        JoinedTerm(isConjunction: true, terms: [termA, termC, termB]);

    // Act

    // Assert
    expect(joinedTermOne, joinedTermTwo);
  });

  test(
      'Given a two independently constructed joined terms from independently constructed literals, when compared with ==, then assert them to be true if they have the same literals',
      () async {
    // Arrange
    JoinedTerm joinedTermOne =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    final termATwo = LiteralTerm(a, notA);
    final termBTwo = LiteralTerm(b, notB);
    final termCTwo = LiteralTerm(c, notC);
    JoinedTerm joinedTermTwo =
        JoinedTerm(isConjunction: true, terms: [termATwo, termCTwo, termBTwo]);

    // Act

    // Assert
    expect(joinedTermOne, joinedTermTwo);
  });
}
