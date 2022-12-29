import 'dart:developer';

import 'package:proof_map/extensions/string_extension.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/model/normal_form.dart';
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
        _terms = _constructTerms(terms, isConjunction),
        super();

  /// Constructs the set of terms enclosed in this JoinedTerm, simplifying
  /// the expression with zero/one element and identity laws.
  static Set<Term> _constructTerms(
      Iterable<Term> terms, bool rootIsConjunction) {
    List<Term> uniqueTerms = Set<Term>.from(terms).toList();

    /// Returns true only if the term is a joined term and contains only a
    /// literal one with no other terms.
    bool isJoinedTermAndLiteralOne(Term term) =>
        (term is JoinedTerm && term.enclosedTerms.first == LiteralTerm.one);

    /// Returns true only if the term is a joined term and contains only a
    /// literal zero with no other terms.
    bool isJoinedTermIsLiteralZero(Term term) =>
        (term is JoinedTerm && term.enclosedTerms.first == LiteralTerm.zero);

    for (int i = 0; i < uniqueTerms.length; i++) {
      Term term = uniqueTerms[i];

      if (term is JoinedTerm && term._isConjunction == rootIsConjunction) {
        uniqueTerms.removeAt(i);
        uniqueTerms.addAll(term._terms.toList());
      }

      if (rootIsConjunction) {
        if (term == LiteralTerm.zero || isJoinedTermIsLiteralZero(term)) {
          // Zero Element
          return {LiteralTerm.zero};
        } else if (uniqueTerms.length > 1 &&
            (term == LiteralTerm.one || isJoinedTermAndLiteralOne(term))) {
          // Identity Law
          uniqueTerms.removeAt(i--);
        }
      } else {
        if (uniqueTerms.length > 1 &&
            (term == LiteralTerm.zero || isJoinedTermIsLiteralZero(term))) {
          // Identity Law
          uniqueTerms.removeAt(i--);
        } else if (term == LiteralTerm.one || isJoinedTermAndLiteralOne(term)) {
          // One Element
          return {LiteralTerm.one};
        }
      }

      for (int j = i + 1; j < uniqueTerms.length; j++) {
        Term compare = uniqueTerms[j];
        if (compare.negate() == term) {
          if (rootIsConjunction) {
            return {LiteralTerm.zero};
          } else {
            return {LiteralTerm.one};
          }
        }
      }
    }

    return uniqueTerms.toSet();
  }

  /// Sorts the terms in this joined term, including the nested joined terms, by
  /// a given comparator. <br/>
  /// For example, calling
  /// ```
  /// joinedTerm.sort((a, b) => a.postulate.compareTo(b.postulate))
  /// ```
  /// where `joinedTerm` is `B + C + A`, will sort this term to produce a new
  /// joined term of `A + B + C` in alphabetical order of postulates
  JoinedTerm sort(Comparator<Term> comparator) {
    List<Term> terms = [];
    for (Term term in _terms) {
      if (term is LiteralTerm) {
        terms.add(term);
      } else {
        terms.add((term as JoinedTerm).sort(comparator));
      }
    }
    terms.sort(comparator);
    return JoinedTerm(isConjunction: _isConjunction, terms: terms);
  }

  @override
  Iterable<LiteralTerm> getUniqueTerms() {
    Set<LiteralTerm> collected = {};

    for (Term term in enclosedTerms) {
      if (term is LiteralTerm) {
        if (!collected.contains(term.negate())) {
          collected.add(term.postulate.last() == "'" ? term.negate() : term);
        }
      } else {
        for (term in term.getUniqueTerms()) {
          if (!collected.contains(term.negate())) {
            collected.add(term);
          }
        }
      }
    }
    return collected;
  }

  /// Simplifies the terms using Quine-McCluskey and returns the result as a
  /// joined term with the least number of repeated variables in the expression.
  /// </br>
  /// This is usually used for the ease of human readability.
  @override
  JoinedTerm simplify([bool usingDisjunctiveNormal = true]) {
    //log(toDisjunctiveNormalForm().joinedTerm.toString());

    Iterable<Implicant> smallestTerms;
    if (usingDisjunctiveNormal) {
      smallestTerms = toDisjunctiveNormalForm().getMinterms();
    } else {
      smallestTerms = toConjunctiveNormalForm().getMaxterms();
    }

    //log(minterms.toList().toString());
    Iterable<Implicant> primeImplicants =
        quine_mccluskey.compute(smallestTerms);

    assert(primeImplicants.isNotEmpty);

    if (primeImplicants.length == 1) {
      // if there is only 1 PI, then it is a conjunction of the minterms
      return JoinedTerm(
          isConjunction: true, terms: primeImplicants.first.terms);
    } else {
      // for every PI, if the PI covers only 1 term, then it is disjunct by
      // only that term. If it covers many terms, then it is disjunct by the
      // conjunction of the terms covered
      List<Term> terms = primeImplicants
          .map((e) => e.terms.length == 1
              ? e.terms.first
              : JoinedTerm(isConjunction: true, terms: e.terms))
          .toList();

      return JoinedTerm(isConjunction: false, terms: terms);
    }
  }

  @override
  DisjunctiveNormalForm toDisjunctiveNormalForm() {
    return _toNormalForm(isConjunctive: false) as DisjunctiveNormalForm;
  }

  @override
  ConjunctiveNormalForm toConjunctiveNormalForm() {
    return _toNormalForm(isConjunctive: true) as ConjunctiveNormalForm;
  }

  NormalForm _toNormalForm({required bool isConjunctive}) {
    // the phrase "if disjunctive" refers to this boolean `isDisjunctive`

    bool isConjunction = _isConjunction;
    List<Term> currentTree = enclosedTerms.toList();

    // Linearly flatten if main tree operator is the same as subtree operator
    for (int i = 0; i < currentTree.length; i++) {
      Term term = currentTree[i];
      if (term is! JoinedTerm) {
        continue;
      }
      // Step 1: Recursively apply the operation to subtrees
      JoinedTerm newSubTree =
          term._toNormalForm(isConjunctive: isConjunctive).joinedTerm;
      currentTree[i] = newSubTree;

      // Step 2: Flatten subtrees if same operators
      if (newSubTree._isConjunction == isConjunction) {
        currentTree.removeAt(i);
        currentTree.insertAll(i, newSubTree.enclosedTerms);
        i += newSubTree.enclosedTerms.length - 1;
      }
    }

    currentTree = currentTree.map((e) {
      if (e is JoinedTerm && e._terms.length == 1) {
        return e._terms.first;
      } else {
        return e;
      }
    }).toList();

    // If main tree is the required disjunction/conjunction, the tree is
    // sufficiently flattened
    if (isConjunction == isConjunctive) {
      if (isConjunctive) {
        return _ConjunctiveNormalForm(
            JoinedTerm(isConjunction: true, terms: currentTree));
      } else {
        return _DisjunctiveNormalForm(
            JoinedTerm(isConjunction: false, terms: currentTree));
      }
    }

    // Distribute the disjunctions (if disjunctive) or conjunctions (if conjunctive)
    // terms until the main branch stops mutating
    for (int i = 0; i < currentTree.length; i++) {
      Term subtree = currentTree[i];
      // At this point, the root node is a conjunction (if disjunctive) or
      // disjunction (if conjunctive)
      // Subtree roots must either be literal terms, or disjunctions (if disjunctive)
      // Conjunctions (if disjunctive) won't exist as they've been flattened
      if (subtree is! JoinedTerm) {
        // continue until a Joined Term is found and mutate this tree/subtree
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
          JoinedTerm(isConjunction: isConjunctive, terms: mutatedTree)
              ._toNormalForm(isConjunctive: isConjunctive)
              .joinedTerm;
      currentTree = mutatedTerms.enclosedTerms.toList();

      // set isConjunction to false if disjunctive and true if conjunctive
      isConjunction = isConjunctive;
      break;
    }

    // At this point, the main root must be a disjunction (if disjunctive) /
    // conjunction (if conjunctive)
    // Compress subtree roots of disjunctions/conjunctions with the main root
    for (int i = 0; i < currentTree.length; i++) {
      Term child = currentTree[i];
      if (child is! JoinedTerm || child._isConjunction != isConjunction) {
        continue;
      }

      currentTree.removeAt(i);
      currentTree.insertAll(i, child.enclosedTerms);
      i += child.enclosedTerms.length - 1;
    }

    if (isConjunctive) {
      return _ConjunctiveNormalForm(
          JoinedTerm(isConjunction: isConjunction, terms: currentTree));
    } else {
      return _DisjunctiveNormalForm(
          JoinedTerm(isConjunction: isConjunction, terms: currentTree));
    }
  }

  /// Describes this term as a statement
  @override
  String get postulate => enclosedTerms
      .map((e) => e is JoinedTerm ? "(${e.postulate})" : e.postulate)
      .join(_isConjunction ? " · " : " + ");

  /// Applies DeMorgan's Law to the present list of terms to perform negation
  @override
  Term negate() => JoinedTerm(
      isConjunction: !_isConjunction,
      terms: enclosedTerms.map((t) => t.negate()));

  @override
  String toString() =>
      "${isConjunction ? "Conjunction" : "Disjunction"} | $postulate";
}

/// A conjunctive normal form is a conjunction of disjunctions of literals or
/// a single term that is a disjunction of literals
class _ConjunctiveNormalForm extends ConjunctiveNormalForm {
  final JoinedTerm _joinedTerm;
  @override
  JoinedTerm get joinedTerm => _joinedTerm;

  _ConjunctiveNormalForm(this._joinedTerm);

  @override
  ConjunctiveNormalForm simplify() {
    Iterable<Implicant> maxterms = getMaxterms();

    Iterable<Implicant> primeImplicants = quine_mccluskey.compute(maxterms);

    assert(primeImplicants.isNotEmpty);

    if (primeImplicants.length == 1) {
      // if there is only 1 PI, then it is a disjunction of the maxterms
      return _ConjunctiveNormalForm(
          JoinedTerm(isConjunction: false, terms: primeImplicants.first.terms));
    } else {
      // for every PI, if the PI covers only 1 term, then it is disjunct by
      // only that term. If it covers many terms, then it is conjunct by the
      // disjunction of the terms covered
      List<Term> terms = primeImplicants
          .map((e) => e.terms.length == 1
              ? e.terms.first
              : JoinedTerm(isConjunction: false, terms: e.terms))
          .toList();

      return _ConjunctiveNormalForm(
          JoinedTerm(isConjunction: true, terms: terms));
    }
  }
}

/// A disjunctive normal form is a disjunction of conjunctions of literals or
/// a single term that is a conjunction of literals
class _DisjunctiveNormalForm extends DisjunctiveNormalForm {
  final JoinedTerm _joinedTerm;
  @override
  JoinedTerm get joinedTerm => _joinedTerm;

  _DisjunctiveNormalForm(this._joinedTerm);

  @override
  DisjunctiveNormalForm simplify() {
    Iterable<Implicant> minterms = getMinterms();

    Iterable<Implicant> primeImplicants = quine_mccluskey.compute(minterms);

    assert(primeImplicants.isNotEmpty);

    if (primeImplicants.length == 1) {
      // if there is only 1 PI, then it is a conjunction of the minterms
      return _DisjunctiveNormalForm(
          JoinedTerm(isConjunction: true, terms: primeImplicants.first.terms));
    } else {
      // for every PI, if the PI covers only 1 term, then it is disjunct by
      // only that term. If it covers many terms, then it is disjunct by the
      // conjunction of the terms covered
      List<Term> terms = primeImplicants
          .map((e) => e.terms.length == 1
              ? e.terms.first
              : JoinedTerm(isConjunction: true, terms: e.terms))
          .toList();

      return _DisjunctiveNormalForm(
          JoinedTerm(isConjunction: false, terms: terms));
    }
  }
}
