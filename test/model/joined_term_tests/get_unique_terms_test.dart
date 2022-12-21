import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import '../../presets/preset_terms.dart';

void main() {
  test(
      "Given a (A · B) + (B · (C + (A' · (D + C))) · (B' + D)), when getting the unique terms, then produces an iterable of A, B, C, D",
      () async {
    // Arrange
    JoinedTerm left = termA.conjunction(termB);
    JoinedTerm notBOrD = termNotB.disjunction(termD);
    JoinedTerm dOrC = termD.disjunction(termC);
    JoinedTerm notAAndDOrC = termNotA.conjunction(dOrC);
    JoinedTerm cOrNotAAndDOrC = termC.disjunction(notAAndDOrC);
    JoinedTerm right = termB.conjunction(cOrNotAAndDOrC, notBOrD);
    JoinedTerm joinedTerm = left.disjunction(right);

    // Act
    Iterable<LiteralTerm> uniqueTerms = joinedTerm.getUniqueTerms();

    // Assert
    expect(uniqueTerms.toSet(), {termA, termB, termC, termD});
  });

  test(
      "Given a (A · B), when getting the unique terms, then produces an iterable of A, B",
      () async {
    // Arrange
    JoinedTerm joinedTerm = termA.conjunction(termB);

    // Act
    Iterable<LiteralTerm> uniqueTerms = joinedTerm.getUniqueTerms();

    // Assert
    expect(uniqueTerms.toSet(), {termA, termB});
  });

  test(
      "Given a (A · B) + (B' · C · D' · D)), when getting the unique terms, then produces an iterable of A, B, C, D",
      () async {
    // Arrange
    JoinedTerm left = termA.conjunction(termB);
    JoinedTerm notBOrD = termNotB.disjunction(termD);
    JoinedTerm dOrC = termD.disjunction(termC);
    JoinedTerm notAAndDOrC = termNotA.conjunction(dOrC);
    JoinedTerm cOrNotAAndDOrC = termC.disjunction(notAAndDOrC);
    JoinedTerm right = termB.conjunction(cOrNotAAndDOrC, notBOrD);
    JoinedTerm joinedTerm = left.disjunction(right);

    // Act
    Iterable<LiteralTerm> uniqueTerms = joinedTerm.getUniqueTerms();

    // Assert
    expect(uniqueTerms.toSet(), {termA, termB, termC, termD});
  });
}
