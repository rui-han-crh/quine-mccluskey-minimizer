import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/model/variable.dart';

import '../presets/preset_variables.dart';

void main() {
  test(
      'Given a statement, when constructed with unnamed constructor, then creates a Variable correctly',
      () async {
    // Arrange
    String statement = "a";

    // Act
    Variable variable = Variable(statement);

    // Assert
    expect(variable.statement, "a");
  });

  test(
      'Given two independently constructed variables, when compared with equality, then correctly determines them to be equal',
      () async {
    // Arrange
    Variable variableA = const Variable("a");

    Variable variableB = const Variable("a");

    // Act
    bool isEqual = variableB == variableA;

    // Assert
    expect(isEqual, true);
  });

  test(
      'Given a constructed variable and a preset, when compared with equality, then correctly determines them to be equal',
      () async {
    // Arrange
    Variable variableA = const Variable("A");

    // Act

    // Assert
    expect(variableA, a);
  });
}
