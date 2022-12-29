import 'package:flutter/material.dart';
import 'package:proof_map/view/expression_text_fields/expression_text_field.dart';

class MaxtermsExpressionTextfield extends ExpressionTextField {
  MaxtermsExpressionTextfield({super.key, required super.model})
      : super(
            onVariablesFocusLost: (value) =>
                model.combinationalSolverState.maxtermVariables = value,
            onIndicesFocusLost: (value) =>
                model.combinationalSolverState.maxtermIndices = value);

  @override
  State<ExpressionTextField> createState() =>
      _ProductOfSumsExpressionTextFieldState();

  @override
  String get text => indicesTextController.text;

  String get variablesText => variablesTextController.text;

  @override
  TextEditingController get indicesTextController => TextEditingController(
      text: model.combinationalSolverState.maxtermIndices);

  @override
  TextEditingController get variablesTextController => TextEditingController(
      text: model.combinationalSolverState.maxtermVariables);
}

class _ProductOfSumsExpressionTextFieldState extends ExpressionTextFieldState {
  @override
  String get termPrefix => "ΠM";

  @override
  String get termHintText => "Maxterms";

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.model.combinationalSolverState.maxtermVariables =
            widget.variablesTextController.text;
        widget.model.combinationalSolverState.maxtermIndices =
            widget.indicesTextController.text;
      }
    });
  }
}
