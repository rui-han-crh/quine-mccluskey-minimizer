import 'dart:developer';

import 'package:proof_map/utils/linear_programming/expression.dart';
import 'package:proof_map/utils/linear_programming/expression_relation.dart';
import 'package:proof_map/utils/messages.dart';

const double bigM = 1.3407807929942596e+200;

/// Minimizes the objective function according to the functions provided in the
/// constraint function. <br>
/// The coefficients of all variables must be supplied, even if it is not
/// participating in the constraint. <br><br>
/// Example of construction: <br>
/// ```
/// binaryMinimize([Expression([1, 0, 0], ExpressionRelation.greaterThanOrEqualsTo, 1),
///          Expression([1, 0, 1], ExpressionRelation.greaterThanOrEqualsTo, 1)])
/// ```
/// This corresponds to a binary integer linear programming calculation
/// minimizing x1 + x2 + x3, subject to constraints x1 >= 1 and x1 + x2 >= 1,
/// such that x1, x2, x3 take values of either 0 or 1. <br><br>
/// The participating variables will be automatically upper bounded by 1 to
/// find results in the domain [0, 1].
List<int> binaryMinimize(List<Expression> constraintFunctions,
    [maximumTableauIterations = 100000]) {
  int numberOfVariables = constraintFunctions[0].coefficients.length;

  // Adds the upper bound of zero to all variables (E.g. x0 <= 1, x1 <= 1, etc)
  for (int i = 0; i < numberOfVariables; i++) {
    List<double> upperBound = List.filled(numberOfVariables, 0);
    upperBound[i] = 1;
    constraintFunctions
        .add(Expression(upperBound, ExpressionRelation.lessThanOrEqualsTo, 1));
  }
  return minimize(List.filled(numberOfVariables, 1), constraintFunctions,
          maximumTableauIterations)
      .map((e) => e.round())
      .toList();
}

/// Minimizes the objective function according to the functions provided in the
/// constraint function. <br>
/// The coefficients of all variables must be supplied, even if it is not
/// participating in the constraint. <br><br>
/// Example of construction: <br>
/// ```
/// minimize([Expression([1, 0, 0], ExpressionRelation.greaterThanOrEqualsTo, 1),
///          Expression([1, 0, 1], ExpressionRelation.greaterThanOrEqualsTo, 1)])
/// ```
/// This corresponds to a linear programming calculation minimizing x1 + x2 + x3,
/// subject to constraints x1 >= 1 and x1 + x2 >= 1
List<double> minimize(List<double> objectiveFunctionCoefficients,
    List<Expression> constraintFunctions,
    [maximumTableauIterations = 10000]) {
  int numberOfVariables = constraintFunctions[0].coefficients.length;
  int numberOfSlackVariables = 0;
  int numberOfArtificialVariables = 0;

  for (Expression ex in constraintFunctions) {
    if (ex.coefficients.length != numberOfVariables) {
      throw ArgumentError.value(
          ex.coefficients, constraintVariablesOfDifferentLength);
    }

    if (ex.relationship != ExpressionRelation.equals) {
      numberOfSlackVariables++;
    }
    if (ex.relationship != ExpressionRelation.lessThanOrEqualsTo) {
      numberOfArtificialVariables++;
    }
  }

  int numberOfRows = constraintFunctions.length;
  int numberOfColumns = numberOfVariables +
      numberOfSlackVariables +
      numberOfArtificialVariables +
      1;

  log("Number of variables: $numberOfVariables, Number of Slack Variables: $numberOfSlackVariables, Number of Artificial Variables: $numberOfArtificialVariables, Number of Rows: $numberOfRows, Number of Columns: $numberOfColumns");

  List<List<double>> matrix =
      List.generate(numberOfRows, (_) => List.filled(numberOfColumns, 0));

  int slackVariableIndex = numberOfVariables;
  int artificialVariableIndex = numberOfVariables + numberOfSlackVariables;
  // Fills in the matrix with respective coefficients and with 1 and -1 for
  // appended variables
  for (int i = 0; i < constraintFunctions.length; i++) {
    // set variables to values in respective constraints
    for (int j = 0; j < constraintFunctions[i].coefficients.length; j++) {
      matrix[i][j] = constraintFunctions[i].coefficients[j];
    }

    if (constraintFunctions[i].relationship ==
        ExpressionRelation.lessThanOrEqualsTo) {
      // slack variable assigned 1
      matrix[i][slackVariableIndex++] = 1;
    } else if (constraintFunctions[i].relationship ==
        ExpressionRelation.greaterThanOrEqualsTo) {
      // slack variable assigned -1
      matrix[i][slackVariableIndex++] = -1;
      // artificial variable assigned 1
      matrix[i][artificialVariableIndex++] = 1;
    } else {
      // artificial variable assigned 1
      matrix[i][artificialVariableIndex++] = 1;
    }

    // assign the last element as result
    matrix[i].last = constraintFunctions[i].result;
  }

  objectiveFunctionCoefficients += List.filled(numberOfSlackVariables, 0.0) +
      List.filled(numberOfArtificialVariables, bigM);

  // number of elements in b is the number of constraints
  List<double> b = List.generate(constraintFunctions.length, (_) => 0);
  List<int> bVar = List.generate(constraintFunctions.length, (_) => -1);

  // assign the coefficients of the b vector according to the basic columns
  // numberOfColumns - 1 to exclude solution variable
  for (int i = 0; i < numberOfColumns - 1; i++) {
    int numberOfNonZeros = 0;
    int lastJIndex = 0;
    for (int j = 0; j < numberOfRows; j++) {
      if (matrix[j][i] == 1) {
        numberOfNonZeros++;
        lastJIndex = j;
      }
    }

    if (numberOfNonZeros == 1) {
      b[lastJIndex] = objectiveFunctionCoefficients[i];
      bVar[lastJIndex] = i;
    }
  }

  assert(bVar.where((e) => e == -1).isEmpty);
  int maxLimit = maximumTableauIterations;
  while (maxLimit > 0) {
    maxLimit--;

    // select pivot column
    int maximumColumn = 0;
    double maximumColumnValue = 0;

    // remember: the number of coeffs is 1 less than the number of columns
    for (int i = 0; i < objectiveFunctionCoefficients.length; i++) {
      double currentValue = 0;
      for (int j = 0; j < numberOfRows; j++) {
        currentValue += matrix[j][i] * b[j];
      } // dot product of b with the current column
      currentValue -= objectiveFunctionCoefficients[i];
      if (currentValue > maximumColumnValue) {
        maximumColumnValue = currentValue;
        maximumColumn = i;
      }
    }

    // terminating condition: there are no positive values
    if (maximumColumnValue == 0) {
      break;
    }

    // select pivot row
    int minimumRow = 0;
    double minimumRowRatio = double.infinity;
    for (int i = 0; i < matrix.length; i++) {
      double xB = matrix[i][maximumColumn];
      if (xB == 0) {
        continue; // skip infinity and negative results
      }

      double currentRowRatio = matrix[i].last / xB;
      if ((currentRowRatio == 0 && xB < 0) || currentRowRatio < 0) {
        //ignore zeros produced by division of negative numbers and negative ratios
        continue;
      }
      if (currentRowRatio < minimumRowRatio) {
        minimumRowRatio = currentRowRatio;
        minimumRow = i;
      }
    }

    double pivotElement = matrix[minimumRow][maximumColumn];

    // replace the current b_i with the incoming variable and value
    b[minimumRow] = objectiveFunctionCoefficients[maximumColumn];
    bVar[minimumRow] = maximumColumn;

    // Rectify pivot row by pivot element only if ratio is not 0 or 1
    // Remember: ratio can take values between 0 and 1
    if (minimumRowRatio != 0 && minimumRowRatio != 1) {
      for (int j = 0; j < numberOfColumns; j++) {
        matrix[minimumRow][j] /= pivotElement;
      }
    }

    // get new pivot element
    pivotElement = matrix[minimumRow][maximumColumn];

    for (int i = 0; i < numberOfRows; i++) {
      if (i == minimumRow) {
        continue; // skip the minimum row
      }

      double columnElement = matrix[i][maximumColumn];

      if (columnElement == 0) {
        continue;
      }

      double ratio = columnElement / pivotElement;
      for (int j = 0; j < numberOfColumns; j++) {
        matrix[i][j] = matrix[i][j] - matrix[minimumRow][j] * ratio;
      }
    }

    // log("----------------------------");
    // log("Selected $maximumColumn, $minimumRow");
    // log("    x1    x2    x3    x4    x5    x6    s1    s2    s3    s4    s5    s6    s7    a1    a2    a3    a4    a5    a6    a7");
    // for (var row in matrix) {
    //   log(row.map((e) => "${" " * (6 - e.toString().length)}$e").join());
    // }
  }

  List<double> result = List.filled(numberOfVariables, 0);
  for (int i = 0; i < bVar.length; i++) {
    if (bVar[i] >= numberOfVariables) {
      continue; // throw away slack and artificial results
    }
    result[bVar[i]] = matrix[i].last;
  }
  //log(b.toString());
  //log(bVar.toString());
  if (maxLimit == 0) {
    throw Exception("Maximum iterations reached");
  }

  log(result.toString());

  return result;
}
