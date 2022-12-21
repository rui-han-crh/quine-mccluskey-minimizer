import 'package:flutter/material.dart';
import 'package:proof_map/model/joined_term.dart';
import 'package:proof_map/model/literal_term.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/parser.dart';
import 'package:proof_map/view/dropdown_expression_form.dart';
import 'package:proof_map/view/expression_text_fields/algebraic_expression_textfield.dart';
import 'package:proof_map/view/expanded_result_text.dart';
import 'package:proof_map/view/expression_input_tabs.dart';
import 'package:proof_map/view/implicant_table.dart';
import 'package:proof_map/view/solution_slide.dart';
import 'package:proof_map/view/submit_button.dart';
import 'package:proof_map/view/expression_text_fields/minterms_expression_textfield.dart.dart';
import 'package:proof_map/view/expression_text_fields/expression_text_field.dart';
import 'package:proof_map/view/utils/expression_form.dart';

class SimplicationPage extends StatefulWidget {
  final Model _model;
  const SimplicationPage(this._model, {super.key});

  @override
  SimplicationPageState createState() => SimplicationPageState();
}

class SimplicationPageState extends State<SimplicationPage> {
  final EdgeInsets paddingInsets = const EdgeInsets.all(10.0);
  Answer _answer = const Answer.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // left of row
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      "Input",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
                Flexible(
                  child: ExpressionInputTabs(widget._model),
                ),
                SubmitButton(
                    model: widget._model,
                    expressionForm: widget._model.expressionForm,
                    setState: () => setState(
                        (() => _answer = widget._model.storage.answer))),
              ],
            ),
          ),
          // Right of row
          Expanded(
            flex: 6,
            child: SolutionSlide(answer: _answer),
          ),
        ],
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final ExpressionForm expressionForm;
  final Model model;
  final void Function() setState;

  const SubmitButton(
      {required this.expressionForm,
      required this.model,
      required this.setState,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          onPressed: onSubmit,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.secondary,
            ),
            foregroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child: const Text("Submit",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void onSubmit() {
    switch (expressionForm) {
      case ExpressionForm.algebraic:
        model.solveAlgebraic(model.storage.algebraicExpression).then((answer) {
          model.replace(answer: answer);
          setState();
        });
        break;
      case ExpressionForm.minterms:
        break;
      case ExpressionForm.maxterms:
        break;
    }
  }
}
