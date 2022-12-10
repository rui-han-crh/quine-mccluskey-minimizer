import 'dart:developer';

import 'package:proof_map/app_object.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/model/variable.dart';

class Parser extends AppObject {
  Parser();

  Term toBooleanExpression(String expression) {
    return _toBooleanExpression(expression
        .split(RegExp("\\s+|(?<=\\()|(?=\\))"))
        .where((e) => e.isNotEmpty)
        .iterator);
  }

  Term _toBooleanExpression(Iterator expressionIterator,
      [List<Term> initialTerms = const [], bool? isConjunction]) {
    List<Term> terms = initialTerms.toList();
    while (expressionIterator.moveNext()) {
      String current = expressionIterator.current;
      log("Current ${current.toString()}");
      switch (current) {
        case "(":
          // next part is a nested expression
          terms.add(_toBooleanExpression(expressionIterator));
          break;
        case ")":
          if (isConjunction == null) {
            throw ArgumentError.notNull();
          }
          // this ends the nested sequence, return to caller
          return JoinedTerm(isConjunction: isConjunction, terms: terms);

        case "*":
        case "·":
          // next operator is conjunction
          // if no current operator, set to conjunction
          isConjunction ??= true;

          if (!isConjunction) {
            // last operator was disjunction
            Term last = terms.removeLast();
            return JoinedTerm(
                isConjunction: false,
                terms: terms +
                    [
                      _toBooleanExpression(expressionIterator, [last], true)
                    ]);
          }
          break;

        case "+":
          // next operator is disjunction
          // if no current operator, set to disjunction
          isConjunction ??= false;

          if (isConjunction) {
            // last operator was conjunction
            terms = [JoinedTerm(isConjunction: true, terms: terms)];
            isConjunction = false;
          }
          break;

        default:
          if (current[current.length - 1] == "'") {
            terms.add(LiteralTerm(Variable(current),
                Variable(current.substring(0, current.length - 1))));
          } else {
            terms.add(LiteralTerm(Variable(current), Variable("$current'")));
          }
      }
    }

    if (isConjunction == null) {
      return terms.first;
    }

    return JoinedTerm(isConjunction: isConjunction, terms: terms);
  }
}
