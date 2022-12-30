import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proof_map/model/answer.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/view/checkbox_with_title.dart';
import 'package:proof_map/view/expression_input_tabs.dart';
import 'package:proof_map/view/number_field_with_title.dart';
import 'package:proof_map/view/solution_slide.dart';
import 'package:proof_map/view/utils/expression_form.dart';

class SimplicationPage extends StatefulWidget {
  final Model _model;
  const SimplicationPage(this._model, {super.key});

  @override
  SimplicationPageState createState() => SimplicationPageState();
}

class SimplicationPageState extends State<SimplicationPage> {
  final EdgeInsets paddingInsets = const EdgeInsets.all(10.0);
  bool toGenerateKMap = false;
  bool toComputeDnf = true;
  bool toComputeCnf = true;

  // will be updated
  late SolutionSlide solutionSlide = SolutionSlide(
    generateKMap: toGenerateKMap,
  );

  bool mintermsStartAsFolded = true;
  bool maxtermsStartAsFolded = true;
  int timeoutSeconds = 15;

  @override
  Widget build(BuildContext context) {
    onPress();
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
                NumberFieldWithTitle(
                  title: "Timeout (seconds)",
                  hintText: "15",
                  onChange: (value) {
                    setState(() {
                      timeoutSeconds = value ?? 15;
                      log("timeoutSeconds set to $value");
                    });
                  },
                ),
                CheckboxWithTitle(
                  title: "Compute Disjunctive Normal Form",
                  startingBooleanValue: toComputeDnf,
                  onChecked: (value) => setState(() => toComputeDnf = value),
                ),
                CheckboxWithTitle(
                  title: "Compute Conjunctive Normal Form",
                  startingBooleanValue: toComputeCnf,
                  onChecked: (value) => setState(() => toComputeCnf = value),
                ),
                CheckboxWithTitle(
                  title: "Draw Karnaugh Maps",
                  startingBooleanValue: toGenerateKMap,
                  onChecked: (value) => toGenerateKMap = value,
                ),
                SubmitButton(
                  model: widget._model,
                  expressionForm: widget._model.expressionForm,
                  setStateCallback: onPress,
                  timeOutSeconds: timeoutSeconds,
                  toComputeCNF: toComputeCnf,
                  toComputeDNF: toComputeDnf,
                ),
              ],
            ),
          ),
          // Right of row
          Expanded(
            flex: 6,
            child: solutionSlide,
          ),
        ],
      ),
    );
  }

  void onPress() {
    setState(
      (() {
        solutionSlide = SolutionSlide(
          // a key must be specified to induce a redraw on the child
          key: ValueKey(widget._model.combinationalSolverState.answer),
          answer: widget._model.combinationalSolverState.answer,
          generateKMap: toGenerateKMap,
          mintermsStartAsFolded: mintermsStartAsFolded,
          maxtermsStartAsFolded: maxtermsStartAsFolded,
          onFoldMintermsTable: (value) => mintermsStartAsFolded = value,
          onFoldMaxtermsTable: (value) => maxtermsStartAsFolded = value,
        );
      }),
    );
  }
}

class SubmitButton extends StatefulWidget {
  final ExpressionForm expressionForm;
  final Model model;
  final void Function() setStateCallback;
  final int timeOutSeconds;
  final bool toComputeDNF;
  final bool toComputeCNF;

  const SubmitButton(
      {required this.expressionForm,
      required this.model,
      required this.setStateCallback,
      required this.timeOutSeconds,
      required this.toComputeDNF,
      required this.toComputeCNF,
      Key? key})
      : super(key: key);

  @override
  State<SubmitButton> createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton> {
  bool isSubmitted = false;

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
          child: isSubmitted
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text("Submit",
                  style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void onSubmit() async {
    // push the current state of the model to the stack, rendering it immutable
    // in the history. A new state is created to be mutated upon
    widget.model.pushCombinationalSolverState();
    setState(() {
      isSubmitted = true;
    });

    log("Minterm variables are: ${widget.model.combinationalSolverState.mintermVariables}");
    log("Minterm indices are: ${widget.model.combinationalSolverState.mintermIndices}");
    log("Timeout: ${widget.timeOutSeconds}");

    switch (widget.model.expressionForm) {
      case ExpressionForm.algebraic:
        if (widget.model.combinationalSolverState.algebraicExpression == "") {
          setState(() {
            isSubmitted = false;
          });
          return;
        }
        await widget.model
            .solveAlgebraic(
          widget.model.combinationalSolverState.algebraicExpression,
          timeoutSeconds: widget.timeOutSeconds,
          computeCnf: widget.toComputeCNF,
          computeDnf: widget.toComputeDNF,
        )
            .then(
          (answer) {
            if (answer != const Answer.empty()) {
              widget.model.combinationalSolverState.answer = answer;
            }

            setState(() {
              isSubmitted = false;
            });
            widget.setStateCallback();
          },
        );
        break;
      case ExpressionForm.minterms:
        if (widget.model.combinationalSolverState.mintermVariables.isEmpty ||
            widget.model.combinationalSolverState.mintermIndices.isEmpty) {
          setState(() {
            isSubmitted = false;
          });
          return;
        }

        await widget.model
            .solveMinterms(
          widget.model.combinationalSolverState.mintermVariables,
          widget.model.combinationalSolverState.mintermIndices,
          timeoutSeconds: widget.timeOutSeconds,
          computeMaxterms: widget.toComputeCNF,
        )
            .then(
          (answer) {
            if (answer != const Answer.empty()) {
              widget.model.combinationalSolverState.answer = answer;
            }

            setState(() {
              isSubmitted = false;
            });
            widget.setStateCallback();
          },
        );
        break;
      case ExpressionForm.maxterms:
        if (widget.model.combinationalSolverState.maxtermVariables.isEmpty ||
            widget.model.combinationalSolverState.maxtermIndices.isEmpty) {
          setState(() {
            isSubmitted = false;
          });
          return;
        }

        await widget.model
            .solveMaxterms(
                widget.model.combinationalSolverState.maxtermVariables,
                widget.model.combinationalSolverState.maxtermIndices,
                timeoutSeconds: widget.timeOutSeconds,
                computeMinterms: widget.toComputeDNF)
            .then(
          (answer) {
            if (answer != const Answer.empty()) {
              widget.model.combinationalSolverState.answer = answer;
            }

            setState(() {
              isSubmitted = false;
            });
            widget.setStateCallback();
          },
        );
        break;
    }
  }
}
