import 'dart:developer';

import 'package:proof_map/app_object.dart';
import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/exceptions/term_not_found_exception.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/extensions/string_format_extension.dart';
import 'package:proof_map/model/term.dart';

import '../utils/messages.dart';

abstract class DisjunctiveNormalForm extends AppObject {
  /// Returns the underlying terms that make up this disjunctive normal form
  JoinedTerm get joinedTerm;

  /// Retrieves the complete set of minterms from this disjunctive normal form <br>
  /// Optionally, pass in an order of all variables that the minterms will be
  /// generated in. If no order is given, the minterms will be recorded in order
  /// of variables seen. <br>
  /// The Set preserves insertion order as a LinkedHashSet <br>
  /// Example: disjunctiveNormalForm.getMinterms([a, b, c]) will generate
  /// valid minterms of abc
  Iterable<Implicant> getMinterms(
      [Iterable<LiteralTerm> orderedVariables = const {}]) {
    if (joinedTerm.isConjunction) {
      return [
        Implicant.create(Map.from({
          for (Term t in joinedTerm.enclosedTerms) t: BinaryValue.binaryOne
        }))
      ];
    }

    // Records the terms in order of seen
    if (orderedVariables.isEmpty) {
      orderedVariables = _getTermsOrder(joinedTerm, {});
    } else {
      orderedVariables = orderedVariables.toSet();
    }

    Set<Implicant> minterms = {};
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
      log("Term $subtree, ${_generateFromDontCareTerms(compulsorySet, difference, orderedVariables as Set<LiteralTerm>).toList().toString()}");
      minterms.addAll(_generateFromDontCareTerms(
          compulsorySet, difference, orderedVariables as Set<LiteralTerm>));
    }
    return minterms;
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
                ? BinaryValue.binaryOne
                : BinaryValue.binaryZero
        }))
      ];
    }

    LiteralTerm nextTerm = dontCareList[i];

    Set<LiteralTerm> compulsorySetWithTerm = Set.from(compulsorySet);
    compulsorySetWithTerm.add(nextTerm);
    Set<LiteralTerm> compulsorySetWithNegatedTerm = Set.from(compulsorySet);
    compulsorySetWithNegatedTerm.add(nextTerm.negate() as LiteralTerm);

    return _generateFromDontCareTerms(
            compulsorySetWithTerm, dontCareList, order, i + 1) +
        _generateFromDontCareTerms(
            compulsorySetWithNegatedTerm, dontCareList, order, i + 1);
  }
}
