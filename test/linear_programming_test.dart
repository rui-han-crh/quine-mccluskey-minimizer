import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/utils/linear_programming/expression.dart';
import 'package:proof_map/utils/linear_programming/expression_relation.dart';
import 'package:proof_map/utils/linear_programming/linear_programming.dart';

void main() {
  test(
      'Given a problem: MINIMIZE Z = x1 + x2 + x3 + x4 + x5 + x6, subject to constraint x1 + x2 >= 1, x1 + x5 >= 1, x3 >= 1, x3 + x6 >= 1, x5 + x6 >= 1, x4 >= 1, x2 + x4 >= 1, x6 >= 1, when computed with 0-1 integer linear programming, then gives an answer x1 = 1, x2 = 0, x3 = 1, x4 = 1, x5 = 0, x6 = 1',
      () async {
    // ARRANGE
    Expression constraintOne = Expression(
        [1, 1, 0, 0, 0, 0], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintTwo = Expression(
        [1, 0, 0, 0, 1, 0], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintThree = Expression(
        [0, 0, 1, 0, 0, 0], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintFour = Expression(
        [0, 0, 1, 0, 0, 1], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintFive = Expression(
        [0, 0, 0, 0, 1, 1], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintSix = Expression(
        [0, 0, 0, 1, 0, 0], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintSeven = Expression(
        [0, 1, 0, 1, 0, 0], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintEight = Expression(
        [0, 0, 0, 0, 0, 1], ExpressionRelation.greaterThanOrEqualsTo, 1);
    // ACT
    List<int> result = binaryMinimize([
      constraintOne,
      constraintTwo,
      constraintThree,
      constraintFour,
      constraintFive,
      constraintSix,
      constraintSeven,
      constraintEight
    ]);

    // ASSERT
    expect(result, [1, 0, 1, 1, 0, 1]);
  });

  test(
      'Given a problem: MINIMIZE Z = x1 + x2 + x3, subject to constraint x1 + x2 >= 1, x2 + x3 <= 1, when computed with 0-1 integer linear programming, then gives an answer x1 = 1, x2 = 0, x3 = 0',
      () async {
    // ARRANGE
    Expression constraintOne =
        Expression([1, 1, 0], ExpressionRelation.greaterThanOrEqualsTo, 1);
    Expression constraintTwo =
        Expression([0, 1, 1], ExpressionRelation.lessThanOrEqualsTo, 1);
    // ACT
    List<int> result = binaryMinimize([constraintOne, constraintTwo]);

    // ASSERT
    expect(result, [1, 0, 0]);
  });

  test(
      'Given a problem: MINIMIZE Z = x1 - x2 + 3x3, subject to constraint x1 + x2 <= 20, x1 + x3 = 5 and x2 + x3 >= 10, when computed with general simplex algorithm, then gives an answer x1 = 0, x2 = 5, x3 = 5',
      () async {
    // ARRANGE
    Expression constraintOne =
        Expression([1, 1, 0], ExpressionRelation.lessThanOrEqualsTo, 20);
    Expression constraintTwo =
        Expression([1, 0, 1], ExpressionRelation.equals, 5);
    Expression constraintThree =
        Expression([0, 1, 1], ExpressionRelation.greaterThanOrEqualsTo, 10);
    // ACT
    List<double> result =
        minimize([1, -1, 3], [constraintOne, constraintTwo, constraintThree]);

    // ASSERT
    expect(result, [5, 15, 0]);
  });

  test(
      'Given a problem: MINIMIZE Z = 10x1 + 16x2 - 5x3, subject to constraint x1 + 3x2 <= 7 and 4x2 + x3 <= 5, when computed with general simplex algorithm, then gives an answer x1 = 0, x2 = 5, x3 = 5',
      () async {
    // ARRANGE
    Expression constraintOne =
        Expression([1, 3, 0], ExpressionRelation.lessThanOrEqualsTo, 7);
    Expression constraintTwo =
        Expression([0, 4, 1], ExpressionRelation.lessThanOrEqualsTo, 5);
    // ACT
    List<double> result =
        minimize([10, 16, -5], [constraintOne, constraintTwo]);

    // ASSERT
    expect(result, [0, 0, 5]);
  });
}
