import 'dart:developer';

import 'package:proof_map/utils/boolean_algebra/binary_value.dart';
import 'package:proof_map/utils/linear_programming/expression.dart';
import 'package:proof_map/utils/linear_programming/expression_relation.dart';
import 'package:proof_map/model/implicant.dart';
import 'package:proof_map/utils/linear_programming/linear_programming.dart'
    as bin_ilp;
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/utils/pair.dart';

Iterable<Implicant> compute(Iterable<Implicant> startingMinterms) {
  // create a collection of groups, index + 1 corresponding to the number of 1s
  // in the minterm
  // -> groups[0] is for implicants with 1 1s, groups[1] is for 2 1s, etc
  for (Implicant im in startingMinterms) {
    log(im.toString());
  }

  List<List<Pair<Implicant, bool>>> groups = List.generate(
      startingMinterms.first.binaryRepresentation.length + 1, (_) => []);

  for (Implicant implicant in startingMinterms) {
    groups[implicant.numberOfOnes].add(Pair(implicant, false));
  }

  bool noChange = false;

  while (!noChange) {
    noChange = true;
    for (int i = 0; i < groups.length - 1; i++) {
      Set<Implicant> alreadyAdded = {};

      // this variable stores the initial length, as more variables will be
      // added behind later and should not be iterated through
      int originalGroupLength = groups[i].length;

      for (int a = 0; a < originalGroupLength; a++) {
        // stopping variable; same purpose as above
        int originalComparisonGroupLength = groups[i + 1].length;
        for (int b = 0; b < originalComparisonGroupLength; b++) {
          // item1 -> implicant, item2 -> whether it has been covered
          if (_isGreyCode(groups[i][a].item1, groups[i + 1][b].item1)) {
            noChange = false;

            // mark both terms as covered
            groups[i][a].item2 = true;
            groups[i + 1][b].item2 = true;

            // add this new expanded implicant to the group if it is not added
            Implicant expandedImplicant =
                _expandImplicant(groups[i][a].item1, groups[i + 1][b].item1);
            if (!alreadyAdded.contains(expandedImplicant)) {
              groups[i].add(Pair(expandedImplicant, false));
              alreadyAdded.add(expandedImplicant);
            }
          }
        }
      }
    }

    // keep only the implicants that haven't been covered
    for (int i = 0; i < groups.length; i++) {
      groups[i] = groups[i].where((e) => !e.item2).toList();
    }
  }

  List<Implicant> primeImplicants =
      groups.expand((e) => e).map((e) => e.item1).toList();

  Map<int, List<double>> coefficients = {};

  // construct the linear programming expression
  for (int i = 0; i < primeImplicants.length; i++) {
    for (int minterm in primeImplicants[i].coveredMintermIndices) {
      if (!coefficients.containsKey(minterm)) {
        // each minterm defines a new expression
        coefficients[minterm] = List.filled(primeImplicants.length, 0);
      }
      // x_i, where x ∈ {0, 1}, corresponding to the ith prime implicant
      // involved in the minterm's expression, which must all sum >= 1
      coefficients[minterm]?[i] = 1;
    }
  }

  // find EPIs with set cover using binary integer linear programming
  List<int> result = bin_ilp.binaryMinimize(coefficients.values
      .map((e) => Expression(e, ExpressionRelation.greaterThanOrEqualsTo, 1))
      .toList());

  // returns a list, each index corresponding to a term and its value being
  // the coefficent. [0, 1, 0, 1, 1] -> x2 + x4 + x5

  return List.generate(result.length, (i) => i)
      .where((i) => result[i] > 0)
      .map((i) => primeImplicants[i]);
}

bool _isGreyCode(Implicant a, Implicant b) {
  List<BinaryValue> binaryA = a.binaryRepresentation.toList();
  List<BinaryValue> binaryB = b.binaryRepresentation.toList();
  int differenceCount = 0;
  for (int i = 0; i < binaryA.length; i++) {
    if (binaryA[i] != binaryB[i]) {
      differenceCount++;
    }
  }
  return differenceCount == 1;
}

/// Groups implicants a and b together by changing their difference bits to
/// don't-cares. <br>
/// There should only be a difference of one 1-bit between a and b
Implicant _expandImplicant(Implicant a, Implicant b) {
  List<BinaryValue> binaryA = a.binaryRepresentation.toList();
  List<BinaryValue> binaryB = b.binaryRepresentation.toList();
  List<LiteralTerm> terms = a.headerTerms;
  Map<LiteralTerm, BinaryValue> newTermMap = {};
  for (int i = 0; i < binaryA.length; i++) {
    newTermMap[terms[i]] =
        binaryA[i] == binaryB[i] ? binaryA[i] : BinaryValue.redundant;
  }
  return Implicant.create(newTermMap);
}
