import 'package:flutter/material.dart';
import 'package:proof_map/view/expression_text_fields/expression_text_field.dart';

class MaxtermsExpressionTextfield extends ExpressionTextField {
  MaxtermsExpressionTextfield({super.key});

  @override
  State<ExpressionTextField> createState() =>
      _ProductOfSumsExpressionTextFieldState();

  @override
  String get text => indicesTextController.text;

  String get variablesText => variablesTextController.text;
}

class _ProductOfSumsExpressionTextFieldState extends ExpressionTextFieldState {
  @override
  String get termPrefix => "ΠM";

  @override
  String get termHintText => "Maxterms";
}
