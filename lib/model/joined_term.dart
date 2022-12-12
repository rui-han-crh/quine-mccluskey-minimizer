import 'dart:developer';

import 'package:proof_map/model/disjunctive_normal_form.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/utils/boolean_algebra/quine_mccluskey.dart'
    as quine_mccluskey;
import 'package:proof_map/model/term.dart';

class JoinedTerm extends Term {
  final bool _isConjunction;
  final Set<Term> _terms;

  @override
  List<Object?> get props => [_isConjunction, _terms];

  Iterable<Term> get enclosedTerms => _terms;

  bool get isConjunction => _isConjunction;

  /// Constructs a joined term with multiple terms and an operator.<br>
  /// If the parameters supplied can be simplified by the Inverse/Complement laws, then this joined term will contain the resultant evaluated expression.<br>
  /// Example: `JoinedTerm(isConjunction: true, terms: [A, notA])` produces `JoinedTerm<LiteralTerm.true>`
  JoinedTerm({required isConjunction, required Iterable<Term> terms})
      : _isConjunction = isConjunction,
        _terms = ((terms) {
          List<Term> uniqueTerms = Set.from(terms).map<Term>((e) => e).toList();

          int i = 0;
          while (i < uniqueTerms.length) {
            Term term = uniqueTerms[i];

            if (term is JoinedTerm && term._isConjunction == isConjunction) {
              uniqueTerms.removeAt(i);
              uniqueTerms.addAll(term._terms.toList());
            }

            if (isConjunction) {
              if (term == LiteralTerm.zero ||
                  (term is JoinedTerm && _joinedTermIsLiteralZero(term))) {
                // Zero Element
                return {LiteralTerm.zero};
              } else if (uniqueTerms.length > 1 &&
                  (term == LiteralTerm.one || _joinedTermIsLiteralOne(term))) {
                // Identity Law
                uniqueTerms.removeAt(i);
                i--;
              }
            } else {
              if (uniqueTerms.length > 1 &&
                  (term == LiteralTerm.zero ||
                      _joinedTermIsLiteralZero(term))) {
                // Identity Law
                uniqueTerms.removeAt(i);
                i--;
              } else if (term == LiteralTerm.one ||
                  _joinedTermIsLiteralOne(term)) {
                // One Element
                return {LiteralTerm.one};
              }
            }

            for (int j = i + 1; j < uniqueTerms.length; j++) {
              Term compare = uniqueTerms[j];
              if (compare.negate() == term) {
                if (isConjunction) {
                  return {LiteralTerm.zero};
                } else {
                  return {LiteralTerm.one};
                }
              }
            }
            i++;
          }

          return uniqueTerms.toSet();
        })(terms),
        super();

  /// Returns true only if the term is a joined term and contains only a
  /// literal one with no other terms
  static bool _joinedTermIsLiteralOne(Term term) =>
      (term is JoinedTerm && term.enclosedTerms.first == LiteralTerm.one);

  /// Returns true only if the term is a joined term and contains only a
  /// literal zero with no other terms
  static bool _joinedTermIsLiteralZero(Term term) =>
      (term is JoinedTerm && term.enclosedTerms.first == LiteralTerm.zero);

  // Simplifies the terms using Quine-McCluskey
  @override
  JoinedTerm simplify() {
    log(toDisjunctiveNormalForm().joinedTerm.toString());
    Iterable<Implicant> minterms = toDisjunctiveNormalForm().getMinterms();
    log(minterms.toList().toString());
    Iterable<Implicant> primeImplicants = quine_mccluskey.compute(minterms);

    assert(primeImplicants.isNotEmpty);

    if (primeImplicants.length == 1) {
      // if there is only 1 PI, then it is a conjunction of the minterms
      return JoinedTerm(
          isConjunction: true, terms: primeImplicants.first.terms);
    } else {
      // for every PI, if the PI covers only 1 term, then it is disjunct by
      // only that term. If it covers many terms, then it is dijunct by the
      // conjunction of the terms covered
      return JoinedTerm(
          isConjunction: false,
          terms: primeImplicants.map((e) => e.terms.length == 1
              ? e.terms.first
              : JoinedTerm(isConjunction: true, terms: e.terms)));
    }
  }

  DisjunctiveNormalForm toDisjunctiveNormalForm() {
    bool isConjunction = _isConjunction;
    List<Term> currentTree = enclosedTerms.toList();

    // Linearly flatten if main tree operator is the same as subtree operator
    for (int i = 0; i < currentTree.length; i++) {
      Term term = currentTree[i];
      if (term is! JoinedTerm) {
        continue;
      }
      // Step 1: Recursively apply the operation to subtrees
      JoinedTerm newSubTree = term.toDisjunctiveNormalForm().joinedTerm;
      currentTree[i] = newSubTree;

      // Step 2: Flatten subtrees if same operators
      if (newSubTree._isConjunction == isConjunction) {
        currentTree.removeAt(i);
        currentTree.insertAll(i, newSubTree.enclosedTerms);
        i += newSubTree.enclosedTerms.length - 1;
      }
    }

    // If main tree is disjunction, the tree is sufficiently flattened
    if (!isConjunction) {
      return _DisjunctiveNormalForm(
          JoinedTerm(isConjunction: false, terms: currentTree));
    }

    // Distribute the disjunctions terms until the main branch stops mutating
    for (int i = 0; i < currentTree.length; i++) {
      Term subtree = currentTree[i];
      // At this point, the root node is a conjunction
      // Subtree roots must either be literal terms, or disjunctions
      // Conjunctions won't exist as they've been flattened
      if (subtree is! JoinedTerm) {
        continue;
      }

      List<Term> mutatedTree = [];
      for (Term child in subtree.enclosedTerms) {
        mutatedTree.add(JoinedTerm(
            isConjunction: isConjunction,
            terms: currentTree.sublist(0, i) +
                [child] +
                currentTree.sublist(i + 1)));
      }
      JoinedTerm mutatedTerms =
          JoinedTerm(isConjunction: false, terms: mutatedTree)
              .toDisjunctiveNormalForm()
              .joinedTerm;
      currentTree = mutatedTerms.enclosedTerms.toList();
      isConjunction = false;
      break;
    }

    // At this point, the main root must be a disjunction
    // Compress subtree roots of disjunctions with the main root
    for (int i = 0; i < currentTree.length; i++) {
      Term child = currentTree[i];
      if (child is! JoinedTerm || child._isConjunction) {
        continue;
      }

      currentTree.removeAt(i);
      currentTree.insertAll(i, child.enclosedTerms);
      i += child.enclosedTerms.length - 1;
    }

    return _DisjunctiveNormalForm(
        JoinedTerm(isConjunction: isConjunction, terms: currentTree));
  }

  // Describes this term as a statement
  @override
  String get statement => enclosedTerms
      .map((e) => e is JoinedTerm ? "(${e.statement})" : e.statement)
      .join(_isConjunction ? " · " : " + ");

  /// Applies DeMorgan's Law to the present list of terms to perform negation
  @override
  Term negate() => JoinedTerm(
      isConjunction: !_isConjunction,
      terms: enclosedTerms.map((t) => t.negate()));

  @override
  String toString() =>
      "${isConjunction ? "Conjunction" : "Disjunction"} | $statement";
}

class _DisjunctiveNormalForm extends DisjunctiveNormalForm {
  final JoinedTerm _joinedTerm;
  @override
  JoinedTerm get joinedTerm => _joinedTerm;

  _DisjunctiveNormalForm(this._joinedTerm);
}
