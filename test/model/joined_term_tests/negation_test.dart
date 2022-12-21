import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/term.dart';
import '../../presets/preset_terms.dart';

void main() {
  test(
      "Given (A · B · C), when negated, then produces the correct negated statement A' + B' + C'",
      () async {
    // Arrange
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    // Act
    Term negatedTerm = joinedTerm.negate();

    // Assert
    expect(negatedTerm.postulate, "A' + B' + C'");
  });

  test(
      'Given (A · B · C), when negated, then compares correctly to another independently created joined term of its negated form',
      () async {
    // Arrange
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termC, termB]);

    JoinedTerm negatedForm = JoinedTerm(
        isConjunction: false,
        terms: [termB.negate(), termC.negate(), termA.negate()]);

    // Act
    Term negatedTerm = joinedTerm.negate();

    // Assert
    expect(negatedTerm, negatedForm);
  });
}
