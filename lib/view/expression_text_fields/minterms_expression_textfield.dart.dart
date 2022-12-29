import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proof_map/view/expression_text_fields/expression_text_field.dart';

class MintermsExpressionTextfield extends ExpressionTextField {
  MintermsExpressionTextfield({super.key, required super.model})
      : super(
            onVariablesFocusLost: (value) =>
                model.combinationalSolverState.mintermVariables = value,
            onIndicesFocusLost: (value) =>
                model.combinationalSolverState.mintermIndices = value);

  @override
  State<ExpressionTextField> createState() =>
      _SumOfProductsExpressionTextFieldState();

  @override
  String get text => indicesTextController.text;

  String get variablesText => variablesTextController.text;

  @override
  TextEditingController get indicesTextController => TextEditingController(
      text: model.combinationalSolverState.mintermIndices);

  @override
  TextEditingController get variablesTextController => TextEditingController(
      text: model.combinationalSolverState.mintermVariables);
}

class _SumOfProductsExpressionTextFieldState extends ExpressionTextFieldState {
  @override
  String get termPrefix => "Σm";

  @override
  String get termHintText => "Minterms";
}
