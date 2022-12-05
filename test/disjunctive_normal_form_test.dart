import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/disjunctive_normal_form.dart';
import 'package:proof_map/exceptions/term_not_found_exception.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/utils/messages.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/extensions/string_format_extension.dart';

import 'util/preset_minterms.dart';
import 'util/preset_terms.dart';

void main() {
  test(
      "Given a joined term of A + (A · B) + (B · C) + (C · A), when converted to minterms of this ABC, produces minterms 3 to 7 with variables ABC",
      () async {
    // Arrange
    JoinedTerm aAndB = termA.conjunction(termB);
    JoinedTerm bAndC = termB.conjunction(termC);
    JoinedTerm cAndA = termC.conjunction(termA);
    JoinedTerm joinedTerm = termA.disjunction(aAndB, bAndC, cAndA);

    // Act
    Iterable<Implicant> minterms =
        joinedTerm.toDisjunctiveNormalForm().getMinterms({termA, termB, termC});

    // Assert
    expect(minterms, {
      abcMintermThree,
      abcMintermFour,
      abcMintermFive,
      abcMintermSix,
      abcMintermSeven
    });
  });

  test(
      "Given a joined term of A + (A · B) + (B · C) + (C · A), when converted to minterms of ABCD, produces minterms 6 to 15 with variables ABCD",
      () async {
    // Arrange
    JoinedTerm aAndB = termA.conjunction(termB);
    JoinedTerm bAndC = termB.conjunction(termC);
    JoinedTerm cAndA = termC.conjunction(termA);
    JoinedTerm joinedTerm = termA.disjunction(aAndB, bAndC, cAndA);

    // Act
    Iterable<Implicant> minterms = joinedTerm
        .toDisjunctiveNormalForm()
        .getMinterms({termA, termB, termC, termD});

    // Assert
    expect(minterms, {
      abcdMintermSix,
      abcdMintermSeven,
      abcdMintermEight,
      abcdMintermNine,
      abcdMintermTen,
      abcdMintermEleven,
      abcdMintermTwelve,
      abcdMintermThirteen,
      abcdMintermFourteen,
      abcdMintermFifteen
    });
  });

  test(
      "Given a joined term of A + (A · B) + (B · C) + (C · A), when converted to minterms of AB, produces an error due to insufficient terms",
      () async {
    // Arrange
    JoinedTerm aAndB = termA.conjunction(termB);
    JoinedTerm bAndC = termB.conjunction(termC);
    JoinedTerm cAndA = termC.conjunction(termA);
    JoinedTerm joinedTerm = termA.disjunction(aAndB, bAndC, cAndA);

    // Act
    DisjunctiveNormalForm expression = joinedTerm.toDisjunctiveNormalForm();

    // Assert
    expect(() => expression.getMinterms({termA, termB}),
        throwsA(TermNotFoundException(termNotFoundMessage.format(termC))));
  });

  test(
      "Given a joined term of (A · B) + (B · C) + (C · A'), when converted to minterms of AB, produces minterms 2, 5, 6, 7",
      () async {
    // Arrange
    JoinedTerm aAndB = termA.conjunction(termB);
    JoinedTerm bAndC = termB.conjunction(termC);
    JoinedTerm cAndNotA = termC.conjunction(termNotA);
    JoinedTerm joinedTerm = aAndB.disjunction(bAndC, cAndNotA);

    // Act
    DisjunctiveNormalForm expression = joinedTerm.toDisjunctiveNormalForm();

    // Assert
    expect(expression.getMinterms({termA, termB, termC}),
        {abcMintermOne, abcMintermThree, abcMintermSix, abcMintermSeven});
  });
}
