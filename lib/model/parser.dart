import 'package:proof_map/app_object.dart';
import 'package:proof_map/exceptions/invalid_argument_exception.dart';
import 'package:proof_map/extensions/string_extension.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/term.dart';
import 'package:proof_map/model/variable.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/utils/messages.dart' as messages;

class Parser extends AppObject {
  Parser();

  final String mintermIndicesRegex = "^\\s*(?:[0-9]*\\s*\\,+\\s*)*[0-9]*\\,*\$";
  final String variablesRegex =
      "^\\s*(?:[a-zA-Z]*\\s*\\,+\\s*)*[a-zA-Z]*\\,*\$";

  /// Parses a string of minterm indices with the total amount of variables
  /// to a boolean expression. </br>
  /// Throws InvalidArgumentException if indices are out of bounds with respect
  /// to the maximum number of minterms that the variables can accomodate. </br>
  /// Throws InvalidArgumentException if either variables or indices are empty
  /// strings.
  Term parseMinterms(String variables, String indices) {
    if (variables.isEmpty) {
      throw InvalidArgumentException(
          messages.cannotBeEmptyString.format("Variables"));
    }

    if (!isValid(variablesRegex, variables)) {
      throw InvalidArgumentException(
          messages.notValid.format([variables, "Variables"]));
    }

    if (indices.isEmpty) {
      throw InvalidArgumentException(
          messages.cannotBeEmptyString.format("Minterm indices"));
    }

    if (!isValid(mintermIndicesRegex, indices)) {
      throw InvalidArgumentException(
          messages.notValid.format([indices, "Minterm indices"]));
    }

    Iterable<LiteralTerm> literals =
        variables.split(",").map((e) => LiteralTerm.fromStatement(e.trim()));

    Iterable<Iterable<BinaryValue>> binaryValues;
    try {
      binaryValues = indices
          .split(",")
          .map((e) => BinaryValueRepresentation.fromInteger(
              int.parse(e), literals.length))
          .toList();
    } on InvalidArgumentException {
      rethrow;
    }

    List<Term> terms = [];
    for (Iterable<BinaryValue> binaryValue in binaryValues) {
      terms.add(
        JoinedTerm(
            isConjunction: true,
            terms: Implicant.create(Map.fromIterables(literals, binaryValue))
                .terms),
      );
    }

    return JoinedTerm(isConjunction: false, terms: terms);
  }

  /// Parses a string of maxterm indices with the total amount of variables
  /// to a boolean expression. </br>
  /// Throws InvalidArgumentException if indices are out of bounds with respect
  /// to the maximum number of maxterms that the variables can accomodate. </br>
  /// Throws InvalidArgumentException if either variables or indices are empty
  /// strings.
  Term parseMaxterms(String variables, String indices) {
    if (variables.isEmpty) {
      throw InvalidArgumentException(
          messages.cannotBeEmptyString.format("Variables"));
    }

    if (!isValid(variablesRegex, variables)) {
      throw InvalidArgumentException(
          messages.notValid.format([variables, "Variables"]));
    }

    if (indices.isEmpty) {
      throw InvalidArgumentException(
          messages.cannotBeEmptyString.format("Maxterm indices"));
    }

    if (!isValid(mintermIndicesRegex, indices)) {
      throw InvalidArgumentException(
          messages.notValid.format([indices, "Maxterm indices"]));
    }

    Iterable<LiteralTerm> literals =
        variables.split(",").map((e) => LiteralTerm.fromStatement(e.trim()));

    Iterable<Iterable<BinaryValue>> binaryValues;
    try {
      binaryValues = indices
          .split(",")
          .map((e) => BinaryValueRepresentation.fromInteger(
              int.parse(e), literals.length))
          .toList();
    } on InvalidArgumentException {
      rethrow;
    }

    List<Term> terms = [];
    for (Iterable<BinaryValue> binaryValue in binaryValues) {
      terms.add(
        JoinedTerm(
            isConjunction: false,
            terms: Implicant.create(Map.fromIterables(literals, binaryValue))
                .terms
                .map((e) => e.negate())),
      );
    }

    return JoinedTerm(isConjunction: true, terms: terms);
  }

  Term parseAlgebraic(String expression) {
    if (expression.isEmpty ||
        expression.replaceAll(RegExp(r"[*·+\'\,]"), "").isEmpty) {
      throw ArgumentError.value(expression);
    }

    return _toBooleanExpression(expression
        .split(RegExp("\\s*(?=\\+|\\·|\\(|\\))|(?<=\\+|\\·|\\(|\\))\\s*"))
        .where((e) => e.isNotEmpty)
        .iterator);
  }

  Term _toBooleanExpression(Iterator expressionIterator,
      [List<Term> initialTerms = const [], bool? isConjunction]) {
    List<Term> terms = initialTerms.toList();
    while (expressionIterator.moveNext()) {
      String current = expressionIterator.current;
      switch (current) {
        case "(":
          // next part is a nested expression
          terms.add(_toBooleanExpression(expressionIterator));
          break;
        case ")":
          if (isConjunction == null) {
            if (terms.length > 1) {
              throw ArgumentError.notNull();
            } else {
              return terms.last;
            }
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

        case "'":
          terms[terms.length - 1] = terms.last.negate();
          break;

        default:
          if (current[current.length - 1] == "'") {
            terms.add(LiteralTerm(Variable(current),
                Variable(current.substring(0, current.length - 1))));
          } else {
            terms.add(LiteralTerm.fromStatement(current));
          }
      }
    }

    if (isConjunction == null) {
      return terms.first;
    }

    return JoinedTerm(isConjunction: isConjunction, terms: terms);
  }

  String parseMintermsToMaxterms(String variables, String mintermIndices) {
    int numberOfVariables = variables.split(",").length;
    int numberOfMinterms = 1 << numberOfVariables;
    Set<int> minterms = mintermIndices.split(",").map(int.parse).toSet();
    return List.generate(numberOfMinterms, (i) => i)
        .where((e) => !minterms.contains(e))
        .join(",");
  }

  String parseMaxtermsToMinterms(String variables, String maxtermIndices) {
    return parseMintermsToMaxterms(variables, maxtermIndices);
  }

  /// Verifies if the string parsed, `stringToVerify`, matches the constraints
  /// specified by the regular expression string, `re`.
  bool isValid(String re, String stringToVerify) {
    return RegExp(re).hasMatch(stringToVerify);
  }
}
