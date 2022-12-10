import 'package:equatable/equatable.dart';
import 'package:proof_map/app_object.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/utils/varargs_function.dart';

abstract class Term extends AppObject with EquatableMixin {
  // Describes this term as a statement
  String get statement;

  Term();

  // Creates the negation of the present term
  Term negate();

  Term simplify();

  // Joins multiple terms with conjunctions
  late final conjunction = VarargsFunction<Term, Term>((args) {
    return JoinedTerm(isConjunction: true, terms: args + [this]);
  }) as dynamic;

  // Joins multiple terms with disjunctions
  late final disjunction = VarargsFunction<Term, Term>((args) {
    return JoinedTerm(isConjunction: false, terms: args + [this]);
  }) as dynamic;
}
