import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:proof_map/app_object.dart';
import 'package:proof_map/exceptions/invalid_argument_exception.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/utils/messages.dart';
import 'package:proof_map/model/prime_implicant.dart';

import '../utils/boolean_algebra/binary_result.dart';
import 'minterm.dart';

abstract class Implicant extends AppObject with EquatableMixin {
  final Map<LiteralTerm, BinaryValue> _terms;
  final int _numberOfOnes;

  @override
  List<Object?> get props => [_terms];

  /// Header terms are the relative terms that are mapped with 0 or 1
  List<LiteralTerm> get headerTerms => _terms.keys.toList();

  List<LiteralTerm> get terms => _terms.entries
      .where((e) => e.value != BinaryValue.redundant)
      .map((e) => (e.value == BinaryValue.binaryOne)
          ? e.key
          : e.key.negate() as LiteralTerm)
      .toList();

  Iterable<BinaryValue> get binaryRepresentation => _terms.values;

  int get numberOfOnes => _numberOfOnes;

  /// Creates a minterm consisting of a variable number of terms and
  /// truthfulnesses. The arguments must be an amount of terms. </br>
  /// Example: Minterm.create(termA, termB, termC, termNotD) -> corresponds
  /// to minterm 1110 for variables ABCD
  Implicant._construct(Map<LiteralTerm, BinaryValue> terms)
      : _terms = Map.of(terms),
        _numberOfOnes =
            terms.values.where((e) => e == BinaryValue.binaryOne).length;

  Implicant()
      : _terms = <LiteralTerm, BinaryValue>{},
        _numberOfOnes = 0;

  static Implicant create(Map<LiteralTerm, BinaryValue> terms) {
    for (BinaryValue result in terms.values) {
      if (result == BinaryValue.redundant) {
        return _PrimeImplicant(terms);
      }
    }
    return _Minterm(terms);
  }

  Implicant arrange(int Function(LiteralTerm, LiteralTerm) comparer) {
    SplayTreeMap<LiteralTerm, BinaryValue> splayTreeMap =
        SplayTreeMap(comparer);

    for (MapEntry<LiteralTerm, BinaryValue> entry in _terms.entries) {
      splayTreeMap[entry.key] = entry.value;
    }
    return Implicant.create(Map.from(splayTreeMap));
  }

  @override
  String toString() =>
      "${_terms.values.map((e) => e.representation).join()} of ${_terms.keys.join()}";
}

class _Minterm extends Implicant implements Minterm {
  _Minterm(terms) : super._construct(terms);
}

class _PrimeImplicant extends Implicant implements PrimeImplicant {
  final List<int> _mintermIndices;

  @override
  Iterable<int> get coveredMintermIndices => _mintermIndices;

  _PrimeImplicant(Map<LiteralTerm, BinaryValue> terms)
      : _mintermIndices = _findIndices(terms.values.toList()),
        super._construct(terms);

  static List<int> _findIndices(List<BinaryValue> binary, [int i = 0]) {
    if (binary.isEmpty) {
      throw ArgumentError(representationEmptyMessage);
    }
    if (i == binary.length) {
      return [0];
    }

    List<int> next = _findIndices(binary, i + 1);

    if (binary[i] == BinaryValue.binaryOne) {
      return next.map((e) => e + (1 << binary.length - 1 - i)).toList();
    } else if (binary[i] == BinaryValue.binaryZero) {
      return next;
    } else {
      return next.map((e) => e + (1 << binary.length - 1 - i)).toList() + next;
    }
  }
}
