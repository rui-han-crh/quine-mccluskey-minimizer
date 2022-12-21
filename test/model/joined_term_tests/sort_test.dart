import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import '../../presets/preset_terms.dart';

void main() {
  test(
      "Given A + (D' · B) + C, when sorted alphabetically, then produces A + (B · D') + C as the postulate",
      () async {
    // Arrange
    JoinedTerm joinedTerm = JoinedTerm(isConjunction: false, terms: [
      termA,
      JoinedTerm(isConjunction: true, terms: [termNotD, termB]),
      termC
    ]);

    // Act
    joinedTerm = joinedTerm.sort((a, b) => a.postulate.compareTo(b.postulate));

    // Assert
    expect(joinedTerm.postulate, "A + (B · D') + C");
  });

  test(
      "Given E + D + C + B + A, when sorted alphabetically, then produces A + B + C + D + E as the postulate",
      () async {
    // Arrange
    JoinedTerm joinedTerm = JoinedTerm(isConjunction: false, terms: [
      termE,
      termD,
      termC,
      termB,
      termA,
    ]);

    // Act
    joinedTerm = joinedTerm.sort((a, b) => a.postulate.compareTo(b.postulate));

    // Assert
    expect(joinedTerm.postulate, "A + B + C + D + E");
  });

  test(
      "Given A + (D' · B · (E + C + A')) + C, when sorted alphabetically, then produces ((A' + C + E) · B · D') + A + C as the postulate",
      () async {
    // Arrange
    JoinedTerm joinedTerm = JoinedTerm(isConjunction: false, terms: [
      termA,
      JoinedTerm(isConjunction: true, terms: [
        termNotD,
        termB,
        JoinedTerm(isConjunction: false, terms: [termE, termC, termNotA])
      ]),
      termC
    ]);

    // Act
    joinedTerm = joinedTerm.sort((a, b) => a.postulate.compareTo(b.postulate));

    // Assert
    expect(joinedTerm.postulate, "((A' + C + E) · B · D') + A + C");
  });
}
