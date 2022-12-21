import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:proof_map/app_object.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/utils/messages.dart';

import '../utils/boolean_algebra/binary_value.dart';

class Implicant extends AppObject with EquatableMixin {
  final Map<LiteralTerm, BinaryValue> _terms;
  final int _numberOfOnes;
  final List<int> _mintermIndices;

  @override
  List<Object?> get props => [_terms];

  /// Header terms are the relative terms that are mapped with 0 or 1
  List<LiteralTerm> get headerTerms => _terms.keys.toList();

  // Retrieves the indices of all the minterms covered
  Iterable<int> get coveredMintermIndices => _mintermIndices;

  /// Retrieves the minterms that this implicant covers. <br>
  /// This will retrieve the header term if the it's value is a one, otherwise,
  /// it will retrieve the negation of the header term. <br>
  /// For example, implicant 1000 of ABCD has terms A, B', C', D'
  List<LiteralTerm> get terms {
    Iterable<MapEntry<LiteralTerm, BinaryValue>> entries =
        _terms.entries.where((e) => e.value != BinaryValue.redundant);

    if (entries.isEmpty) {
      return [LiteralTerm.one];
    }
    return entries
        .map((e) => (e.value == BinaryValue.binaryOne) ? e.key : e.key.negate())
        .toList();
  }

  /// Returns the binary representation as a list of BinaryValues
  Iterable<BinaryValue> get binaryRepresentation => _terms.values;

  /// Returns the binary representaiton as a string of ones, zeros and dont-cares
  String get binaryString =>
      binaryRepresentation.map((e) => e.representation).join();

  int get numberOfOnes => _numberOfOnes;

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

  /// Creates a minterm consisting of a variable number of terms and
  /// truthfulnesses. The arguments must be an amount of terms. </br>
  /// Example: </br>
  /// ```
  /// Minterm.create(
  ///   {termA: BinaryValue.one,
  ///    termB: BinaryValue.one,
  ///    termC: BinaryValue.one,
  ///    termD: BinaryValue.zero
  ///   }
  /// )
  /// ```
  /// to minterm 1110 for variables ABCD
  Implicant.create(Map<LiteralTerm, BinaryValue> terms)
      : _terms = Map.of(terms),
        _numberOfOnes =
            terms.values.where((e) => e == BinaryValue.binaryOne).length,
        _mintermIndices = _findIndices(terms.values.toList());

  Implicant()
      : _terms = <LiteralTerm, BinaryValue>{},
        _numberOfOnes = 0,
        _mintermIndices = [];

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
