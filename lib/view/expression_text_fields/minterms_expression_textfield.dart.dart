import 'package:flutter/material.dart';
import 'package:proof_map/view/expression_text_fields/expression_text_field.dart';

class MintermsExpressionTextfield extends ExpressionTextField {
  MintermsExpressionTextfield({super.key});

  @override
  State<ExpressionTextField> createState() =>
      _SumOfProductsExpressionTextFieldState();

  @override
  String get text => indicesTextController.text;

  String get variablesText => variablesTextController.text;
}

class _SumOfProductsExpressionTextFieldState extends ExpressionTextFieldState {
  @override
  String get termPrefix => "Σm";

  @override
  String get termHintText => "Minterms";
}
