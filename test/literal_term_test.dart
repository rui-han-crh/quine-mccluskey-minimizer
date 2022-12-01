import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/literal_term.dart';
import 'package:proof_map/variable.dart';

void main() {
  const String statement = "A";
  const String oppositeStatement = "A'";

  const Variable variable = Variable(statement);
  const Variable negatedVariable = Variable(oppositeStatement);

  test(
      "Given a statement and an opposite statement, when constructed with fromStatements constructor, then creates a literal term correctly",
      () async {
    // Arrange

    // Act
    LiteralTerm literalTerm =
        LiteralTerm.fromStatements(statement, oppositeStatement);

    // Assert
    expect(literalTerm.currentVariable.statement, statement);
    expect(literalTerm.negatedVariable.statement, oppositeStatement);
  });

  test(
      "Given a variable and its negated form, when constructed with nameless constructor, then creates a literal term correctly",
      () async {
    // Arrange

    // Act
    LiteralTerm literalTerm = LiteralTerm(variable, negatedVariable);

    // Assert
    expect(literalTerm.currentVariable.statement, statement);
    expect(literalTerm.negatedVariable.statement, oppositeStatement);
  });

  test(
      "Given a variable and its negated form, when constructed with nameless constructor, then creates a literal term correctly",
      () async {
    // Arrange

    // Act
    LiteralTerm literalTerm = LiteralTerm(variable, negatedVariable);

    // Assert
    expect(literalTerm.currentVariable.statement, statement);
    expect(literalTerm.negatedVariable.statement, oppositeStatement);
  });

  test(
      "Given an existing literal variable, when negated, then creates its negated form's statements correctly",
      () async {
    // Arrange
    LiteralTerm literalTerm = LiteralTerm(variable, negatedVariable);

    // Act
    LiteralTerm negatedTerm = literalTerm.negate() as LiteralTerm;

    // Assert
    expect(negatedTerm.currentVariable.statement, oppositeStatement);
    expect(negatedTerm.negatedVariable.statement, statement);
  });

  test(
      "Given an existing literal variable, when negated, then each corresponding variable is correctly equated to independently constructed variables",
      () async {
    // Arrange
    Variable variableIndependent = const Variable(statement);
    Variable negatedVariableIndependent = const Variable(oppositeStatement);
    LiteralTerm literalTerm = LiteralTerm(variable, negatedVariable);

    // Act
    LiteralTerm negatedTerm = literalTerm.negate() as LiteralTerm;

    // Assert
    expect(negatedTerm.currentVariable, negatedVariableIndependent);
    expect(negatedTerm.negatedVariable, variableIndependent);
  });
}
