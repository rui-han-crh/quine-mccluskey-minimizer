import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/utils/linear_programming/expression.dart';
import 'package:proof_map/utils/linear_programming/expression_relation.dart';

void main() {
  test(
      "Given expression x1 >= 1 of [x1, x2, x3], when constructed, creates an expression contains coefficients [1, 0, 0], relationship >= and result of 1",
      () async {
    // ARRANGE

    // ACT
    Expression expression =
        Expression([1, 0, 0], ExpressionRelation.greaterThanOrEqualsTo, 1);

    // ASSERT
    expect(expression.toString(), "1.0 0.0 0.0 >= 1.0");
  });

  test(
      '''Given expressions
          x1 + x2 + x3 + x4 >= 1
      , when constructed, creates an expression contains coefficients [1, 1, 1, 1], relationship >= and result of 1''',
      () async {
    // ARRANGE

    // ACT
    Expression expression =
        Expression([1, 1, 1, 1], ExpressionRelation.greaterThanOrEqualsTo, 1);

    // ASSERT
    expect(expression.toString(), "1.0 1.0 1.0 1.0 >= 1.0");
  });
}
