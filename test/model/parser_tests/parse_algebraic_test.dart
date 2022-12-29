import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/parser.dart';
import 'package:proof_map/model/term.dart';

import '../../presets/preset_terms.dart';

void main() {
  test(
      'Given a string expression A + B + C · D + E, when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A + B + ((C · D) + E)',
      () async {
    // ARRANGE
    String inputString = "A + B + C · D + E";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(
        booleanExpression,
        JoinedTerm(isConjunction: false, terms: [
          termA,
          termB,
          JoinedTerm(isConjunction: false, terms: [
            JoinedTerm(isConjunction: true, terms: [termC, termD]),
            termE
          ]),
        ]));
  });

  test(
      'Given a string expression A · B + C · D + E, when parsed to a boolean algebra joined term, then correctly produces JoinedTerm (A · B) + ((C · D) + E)',
      () async {
    // ARRANGE
    String inputString = "A · B + C · D + E";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(
        booleanExpression,
        JoinedTerm(isConjunction: false, terms: [
          JoinedTerm(isConjunction: true, terms: [termA, termB]),
          JoinedTerm(isConjunction: false, terms: [
            JoinedTerm(isConjunction: true, terms: [termC, termD]),
            termE
          ]),
        ]));
  });

  test(
      'Given a string expression A · (B + C + D), when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A · (B + C + D)',
      () async {
    // ARRANGE
    String inputString = "A · (B + C + D)";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(
        booleanExpression,
        JoinedTerm(isConjunction: true, terms: [
          termA,
          JoinedTerm(isConjunction: false, terms: [termB, termC, termD]),
        ]));
  });

  test(
      'Given a string expression B + C + D, when parsed to a boolean algebra joined term, then correctly produces JoinedTerm B + C + D',
      () async {
    // ARRANGE
    String inputString = "B + C + D";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(booleanExpression,
        JoinedTerm(isConjunction: false, terms: [termB, termC, termD]));
  });

  test(
      'Given a string expression A · B · C + D + E, when parsed to a boolean algebra joined term, then correctly produces JoinedTerm (A · B · C) + D + E',
      () async {
    // ARRANGE
    String inputString = "A · B · C + D + E";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(
        booleanExpression,
        JoinedTerm(isConjunction: false, terms: [
          JoinedTerm(isConjunction: true, terms: [termA, termB, termC]),
          termD,
          termE
        ]));
  });

  test(
      'Given a string expression A · B, when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A · B',
      () async {
    // ARRANGE
    String inputString = "A · B";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(booleanExpression,
        JoinedTerm(isConjunction: true, terms: [termA, termB]));
  });

  test(
      'Given a string expression A + B, when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A + B',
      () async {
    // ARRANGE
    String inputString = "A + B";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(booleanExpression,
        JoinedTerm(isConjunction: false, terms: [termA, termB]));
  });

  test(
      'Given a string expression A, when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A',
      () async {
    // ARRANGE
    String inputString = "A";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(booleanExpression, termA);
  });

  test(
      "Given a string expression (A + B)', when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A' · B'",
      () async {
    // ARRANGE
    String inputString = "(A + B)'";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(booleanExpression,
        JoinedTerm(isConjunction: true, terms: [termNotA, termNotB]));
  });

  test(
      "Given a string expression ((A + B)')', when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A + B",
      () async {
    // ARRANGE
    String inputString = "((A + B)')'";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(booleanExpression,
        JoinedTerm(isConjunction: false, terms: [termA, termB]));
  });

  test(
      "Given a string expression ((A + B · C)' · D · (E + C')')', when parsed to a boolean algebra joined term, then correctly produces JoinedTerm A + B + D' + E + C'",
      () async {
    // ARRANGE
    String inputString = "((A + B · C)' · D · (E + C')')'";
    Parser p = Parser();

    // ACT
    Term booleanExpression = p.parseAlgebraic(inputString);

    // ASSERT
    expect(
        booleanExpression,
        JoinedTerm(isConjunction: false, terms: [
          termA,
          JoinedTerm(isConjunction: true, terms: [termB, termC]),
          termNotD,
          JoinedTerm(isConjunction: false, terms: [termE, termNotC])
        ]));
  });
}
