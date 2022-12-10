import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/disjunctive_normal_form.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/term.dart';
import '../../presets/preset_terms.dart';
import '../../presets/preset_variables.dart';

void main() {
  test(
      'Given a joined term, when negated, then produces the correct negated statement',
      () async {
    // Arrange
    JoinedTerm joinedTerm =
        JoinedTerm(isConjunction: true, terms: [termA, termB, termC]);

    // Act
    Term negatedTerm = joinedTerm.negate();

    // Assert
    expect(negatedTerm.statement, "A' + B' + C'");
  });

  test(
      'Given a joined term, when negated, then compares correctly to another independently created joined term of its negated form',
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
