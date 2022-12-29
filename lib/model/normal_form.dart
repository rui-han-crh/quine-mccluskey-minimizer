import 'package:proof_map/app_object.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/exceptions/term_not_found_exception.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/extensions/string_extension.dart';
import 'package:proof_map/model/term.dart';

import '../utils/messages.dart';

/// Represents a level-2 joined term of first-level disjunctions </br>
/// Examples of disjunctive normal forms: </br>
/// ```
/// A + B
/// A + (B · C)
/// A + B + (A · C) + (B · D) + D
/// ```
abstract class DisjunctiveNormalForm extends NormalForm {
  /// Retrieves the complete set of minterms from this [DisjunctiveNormalForm] <br>
  /// Optionally, pass in an order of all variables that the minterms will be
  /// generated in. If no order is given, the minterms will be recorded in order
  /// of variables seen. <br>
  /// The `Set` preserves insertion order as a `LinkedHashSet` <br>
  /// Example: `disjunctiveNormalForm.getMinterms([a, b, c])` will generate
  /// valid minterms of abc
  Iterable<Implicant> getMinterms(
      [Iterable<LiteralTerm> orderedVariables = const {}]) {
    return super._getMinOrMaxTerms(true, orderedVariables);
  }

  /// Retrieves an iterable of essential prime implicants of this disjunctive
  /// normal form <br>
  Iterable<Implicant> getEssentialPrimeImplicants(
      Iterable<LiteralTerm> headerValues) {
    return super._getEssentialPrimeImplicants(
        isSoleTerm: joinedTerm.isConjunction, headerTermsOrder: headerValues);
  }

  /// Simplifies this disjunctive normal form by removing redundant terms and
  /// returns the simplest sum-of-products
  @override
  DisjunctiveNormalForm simplify();
}

/// Represents a level-2 joined term of first-level conjunctions </br>
/// Examples of conjunctive normal forms: </br>
/// ```
/// A · B
/// A · (B + C)
/// A · B · (A + C) · (B + D) + D
/// ```
abstract class ConjunctiveNormalForm extends NormalForm {
  /// Retrieves the complete set of minterms from this [ConjunctiveNormalForm] <br>
  /// Optionally, pass in an order of all variables that the maxterms will be
  /// generated in. If no order is given, the maxterms will be recorded in order
  /// of variables seen. <br>
  /// The `Set` preserves insertion order as a `LinkedHashSet` <br>
  /// Example: `conjunctiveNormalForm.getMaxterms([a, b, c])` will generate
  /// valid maxterms of abc
  Iterable<Implicant> getMaxterms(
      [Iterable<LiteralTerm> orderedVariables = const {}]) {
    return super._getMinOrMaxTerms(false, orderedVariables);
  }

  /// Retrieves an iterable of essential prime implicants of this conjunctive
  /// normal form <br>
  Iterable<Implicant> getEssentialPrimeImplicants(
      Iterable<LiteralTerm> headerValues) {
    return super._getEssentialPrimeImplicants(
        isSoleTerm: !joinedTerm.isConjunction, headerTermsOrder: headerValues);
  }

  /// Simplifies this conjunctive normal form by removing redundant terms and
  /// returns the simplest product-of-sums
  @override
  ConjunctiveNormalForm simplify();
}

abstract class NormalForm extends AppObject {
  /// The expression that is returned on a toString() call. This value will be
  /// cached on the first call to toString()
  String? _expression;

  /// Returns the underlying terms that make up this disjunctive normal form
  JoinedTerm get joinedTerm;

  /// Simplifies this normal form
  NormalForm simplify();

  /// Finds all the essential prime implicants of this normal form
  Iterable<Implicant> _getEssentialPrimeImplicants(
      {required bool isSoleTerm,
      required Iterable<LiteralTerm> headerTermsOrder}) {
    if (isSoleTerm) {
      // the entire enclosed term is 1 prime implicant
      return [
        Implicant.create(
          Map.fromIterable(
            headerTermsOrder,
            key: (e) => e,
            value: (e) {
              e = e as LiteralTerm;
              return joinedTerm.enclosedTerms.contains(e)
                  ? BinaryValue.one
                  : joinedTerm.enclosedTerms.contains(e.negate())
                      ? BinaryValue.zero
                      : BinaryValue.dontCare;
            },
          ),
        )
      ];
    } else {
      // the collection of terms in this enclosed term contain many
      // essential prime implicants
      return joinedTerm.enclosedTerms.map(
        (enclosedTerm) => enclosedTerm is JoinedTerm
            ? Implicant.create(
                Map.fromIterable(
                  headerTermsOrder,
                  key: (e) => e,
                  value: (e) {
                    e = e as LiteralTerm;
                    return enclosedTerm.enclosedTerms.contains(e)
                        ? BinaryValue.one
                        : enclosedTerm.enclosedTerms.contains(e.negate())
                            ? BinaryValue.zero
                            : BinaryValue.dontCare;
                  },
                ),
              )
            : Implicant.create(
                {
                  for (LiteralTerm e in headerTermsOrder)
                    e: e == enclosedTerm
                        ? BinaryValue.one
                        : e.negate() == enclosedTerm
                            ? BinaryValue.zero
                            : BinaryValue.dontCare
                },
              ),
      );
    }
  }

  /// Retrieves the complete set of min or max terms from this normal form <br>
  /// Optionally, pass in an order of all variables that the min or max terms
  /// will be generated in. If no order is given, the minterms will be recorded
  /// in order of variables seen. <br>
  /// The Set preserves insertion order as a LinkedHashSet <br>
  Iterable<Implicant> _getMinOrMaxTerms(bool isMinterm,
      [Iterable<LiteralTerm> orderedVariables = const {}]) {
    // Records the terms in order of seen
    if (orderedVariables.isEmpty) {
      orderedVariables = _getTermsOrder(joinedTerm, {});
    } else {
      orderedVariables = orderedVariables.toSet();
    }

    if (joinedTerm.isConjunction == isMinterm) {
      // joinedTerm root is conjunction and requires minterms
      // -> joined term is the minterm
      // joinedTerm root is disjunction and requires maxterms
      // -> joined term is the maxterm
      return [
        Implicant.create(
          {
            // for each variable, if it is in the joined term, it is a 1
            // if it's negation is in the joined term, it is a 0
            // if neither the variable nor its negation is in the joined term,
            // an exception is thrown
            for (var element in orderedVariables)
              element: joinedTerm.enclosedTerms.contains(element)
                  ? BinaryValue.one
                  : joinedTerm.enclosedTerms.contains(element.negate())
                      ? BinaryValue.zero
                      : throw TermNotFoundException(
                          termNotFoundMessage.format(element.toString()))
          },
        )
      ];
    }

    Set<Implicant> simplestImplicants = {};
    for (Term subtree in joinedTerm.enclosedTerms) {
      // A set of compulsory variables that have binary values determined
      Set<LiteralTerm> compulsorySet;
      // A set of not included variables that would take any value
      List<LiteralTerm> difference = [];

      if (subtree is! JoinedTerm) {
        // there will only be one compulsory term, the rest of the terms take
        // any value
        difference = orderedVariables
            .where((e) => e != subtree && e != subtree.negate())
            .toList();
        compulsorySet = {subtree as LiteralTerm};
      } else {
        // the compulsory terms are all the terms in this subtree
        compulsorySet = subtree.enclosedTerms.map<LiteralTerm>((e) {
          if (!orderedVariables.contains(e) &&
              !orderedVariables.contains(e.negate())) {
            // the term in the compulsory set doesn't exist in the order
            throw TermNotFoundException(termNotFoundMessage.format(e));
          }
          return e as LiteralTerm;
        }).toSet();

        for (LiteralTerm term in orderedVariables) {
          if (!compulsorySet.contains(term) &&
              !compulsorySet.contains(term.negate())) {
            difference.add(term);
          }
        }
      }

      simplestImplicants.addAll(_generateFromDontCareTerms(
          compulsorySet, difference, orderedVariables as Set<LiteralTerm>));
    }
    return simplestImplicants;
  }

  Set<LiteralTerm> _getTermsOrder(Term tree, Set<LiteralTerm> currentSet) {
    if (tree is! JoinedTerm) {
      if (!currentSet.contains(tree) && !currentSet.contains(tree.negate())) {
        currentSet.add(tree as LiteralTerm);
      }
      return currentSet;
    }

    for (Term subtree in tree.enclosedTerms) {
      currentSet = _getTermsOrder(subtree, currentSet);
    }
    return currentSet;
  }

  /// Generates all the permutations of minterms from a group of compulsory
  /// terms and a group of don't-care-terms. <br>
  /// The parameter i is used to index the current don't-care-term of this
  /// current recursive level.
  List<Implicant> _generateFromDontCareTerms(Set<LiteralTerm> compulsorySet,
      List<LiteralTerm> dontCareList, Set<LiteralTerm> order,
      [int i = 0]) {
    if (i == dontCareList.length) {
      // all terms in the order list are in the compulsory set
      return [
        Implicant.create(Map.from({
          for (LiteralTerm term in order)
            term: compulsorySet.contains(term)
                ? BinaryValue.one
                : BinaryValue.zero
        }))
      ];
    }

    LiteralTerm nextTerm = dontCareList[i];

    Set<LiteralTerm> compulsorySetWithTerm = Set.from(compulsorySet);
    compulsorySetWithTerm.add(nextTerm);
    Set<LiteralTerm> compulsorySetWithNegatedTerm = Set.from(compulsorySet);
    compulsorySetWithNegatedTerm.add(nextTerm.negate());

    return _generateFromDontCareTerms(
            compulsorySetWithTerm, dontCareList, order, i + 1) +
        _generateFromDontCareTerms(
            compulsorySetWithNegatedTerm, dontCareList, order, i + 1);
  }

  @override
  String toString() {
    _expression ??=
        joinedTerm.sort((a, b) => a.postulate.compareTo(b.postulate)).postulate;
    return _expression!;
  }
}
