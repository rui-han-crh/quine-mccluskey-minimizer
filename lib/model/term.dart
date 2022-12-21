import 'package:equatable/equatable.dart';
import 'package:proof_map/app_object.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/normal_form.dart';
import 'package:proof_map/utils/varargs_function.dart';

abstract class Term extends AppObject with EquatableMixin {
  /// Describes this term as a statement
  String get postulate;

  Term();

  /// Creates the negation of the present term
  Term negate();

  Term simplify();

  /// Joins multiple terms with conjunctions
  late final conjunction = VarargsFunction<Term, Term>((args) {
    return JoinedTerm(isConjunction: true, terms: args + [this]);
  }) as dynamic;

  /// Joins multiple terms with disjunctions
  late final disjunction = VarargsFunction<Term, Term>((args) {
    return JoinedTerm(isConjunction: false, terms: args + [this]);
  }) as dynamic;

  DisjunctiveNormalForm toDisjunctiveNormalForm();

  ConjunctiveNormalForm toConjunctiveNormalForm();

  /// Returns all the unique terms in this term, without including any negated
  /// variables. </br>
  /// For example, if the term is `(A + B) · (A' + C)`, then the unique terms are
  /// `A, B and C`
  Iterable<LiteralTerm> getUniqueTerms();
}
