import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/view/dropdown_expression_form.dart';
import 'package:proof_map/view/boolean_expression_text_field.dart';
import 'package:proof_map/view/expanded_result_text.dart';
import 'package:proof_map/view/submit_button.dart';
import 'package:proof_map/view/sum_of_products_expression_text_field.dart';
import 'package:proof_map/view/text_field.dart';
import 'package:proof_map/view/utils/expression_form.dart';

class HomePage extends StatefulWidget {
  final Model _model;
  const HomePage(this._model, {super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final EdgeInsets paddingInsets = const EdgeInsets.all(20.0);

  late ExpressionForm _expressionForm = widget._model.expressionForm;
  String? _result;

  @override
  Widget build(BuildContext context) {
    ExpressionTextField textField;
    SubmitButton submitButton;

    switch (_expressionForm) {
      case ExpressionForm.sumOfProducts:
        textField = const SumOfProductsExpressionTextField();
        submitButton = SumOfProductsSubmitButton(
          model: widget._model,
          getVariablesCallback: () =>
              (textField as SumOfProductsExpressionTextField).variablesText,
          getTextCallback: () => textField.text,
          assignResultCallback: (value) => setState(() {
            _result = value;
          }),
        );
        break;

      case ExpressionForm.booleanExpression:
      default:
        textField = const BooleanExpressionTextField();
        submitButton = SubmitButton(
          model: widget._model,
          getTextCallback: () => textField.text,
          assignResultCallback: (value) => setState(() {
            _result = value;
          }),
        );
    }

    return Scaffold(
      body: Padding(
        padding: paddingInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownExpressionForm(
              changeExpressionFormCallback: (form) =>
                  setState(() => _expressionForm = form),
            ),
            textField,
            const SizedBox(height: 10),
            submitButton,
            ExpandedResultText(result: _result ?? "NOTHING"),
          ],
        ),
      ),
    );
  }
}
