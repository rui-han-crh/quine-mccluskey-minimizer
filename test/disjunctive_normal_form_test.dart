import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/disjunctive_normal_form.dart';
import 'package:proof_map/exceptions/term_not_found_exception.dart';
import 'package:proof_map/joined_term.dart';
import 'package:proof_map/messages.dart';
import 'package:proof_map/minterm.dart';
import 'package:proof_map/string_format_extension.dart';

import 'util/preset_minterms.dart';
import 'util/preset_terms.dart';

void main() {
  test(
      "Given a joined term of A + (A · B) + (B · C) + (C · A), when converted to minterms of this ABC, produces minterms 6 to 15 with variables ABC",
      () async {
    // Arrange
    JoinedTerm aAndB = termA.conjunction(termB);
    JoinedTerm bAndC = termB.conjunction(termC);
    JoinedTerm cAndA = termC.conjunction(termA);
    JoinedTerm joinedTerm = termA.disjunction(aAndB, bAndC, cAndA);

    // Act
    Iterable<Minterm> minterms =
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
    Iterable<Minterm> minterms = joinedTerm
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
}
