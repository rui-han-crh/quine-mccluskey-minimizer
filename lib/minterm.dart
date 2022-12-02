import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:proof_map/app_object.dart';
import 'package:proof_map/literal_term.dart';
import 'package:proof_map/term.dart';

import 'binary_result.dart';

class Minterm extends AppObject with EquatableMixin {
  final LinkedHashMap<LiteralTerm, BinaryResult> _terms;

  @override
  List<Object?> get props => [_terms];

  List<Term> get terms => _terms.entries
      .where((e) => e.value != BinaryResult.binaryTrueOrFalse)
      .map((e) => (e.value == BinaryResult.binaryTrue) ? e.key : e.key.negate())
      .toList();

  /// Creates a minterm consisting of a variable number of terms and
  /// truthfulnesses. The arguments must be an amount of terms. </br>
  /// Example: Minterm.create(termA, termB, termC, termNotD) -> corresponds
  /// to minterm 1110 for variables ABCD
  Minterm(this._terms);

  Minterm arrange(int Function(LiteralTerm, LiteralTerm) comparer) {
    SplayTreeMap<LiteralTerm, BinaryResult> splayTreeMap =
        SplayTreeMap(comparer);

    for (MapEntry<LiteralTerm, BinaryResult> entry in _terms.entries) {
      splayTreeMap[entry.key] = entry.value;
    }
    return Minterm(LinkedHashMap.from(splayTreeMap));
  }

  @override
  String toString() =>
      "${_terms.values.map((e) => e.representation).join()} of ${_terms.keys.join()}";
}
