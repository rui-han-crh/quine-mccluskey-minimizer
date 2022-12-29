import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/view/expression_text_fields/indices_row.dart';
import 'package:proof_map/view/expression_text_fields/variable_row.dart';

abstract class ExpressionTextField extends StatefulWidget {
  ExpressionTextField({
    super.key,
    required this.model,
    required this.onVariablesFocusLost,
    required this.onIndicesFocusLost,
  });

  final Model model;
  final Function(String) onVariablesFocusLost;
  final Function(String) onIndicesFocusLost;

  TextEditingController get indicesTextController;
  TextEditingController get variablesTextController;

  @override
  State<ExpressionTextField> createState();

  String get text;
}

abstract class ExpressionTextFieldState extends State<ExpressionTextField> {
  final HSVColor _defaultDeleteButtonColor =
      const HSVColor.fromAHSV(1, 238, 0.78, 0.96);
  final HSVColor _pressedDeleteButtonColor =
      const HSVColor.fromAHSV(1, 359, 0.78, 0.96);
  late HSVColor _deleteButtonColor = _defaultDeleteButtonColor;

  String get termPrefix;

  String get termHintText;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  children: [
                    IntrinsicHeight(
                      // all children in the VariableRow must have the same height
                      child: VariableRow(widget.variablesTextController,
                          onFocusLost: widget.onVariablesFocusLost),
                    ),
                    const SizedBox(height: 10),
                    IntrinsicHeight(
                      // all children in the IndicesRow must have the same height
                      child: IndicesRow(
                          termPrefix: termPrefix,
                          termHintText: termHintText,
                          indicesTextController: widget.indicesTextController,
                          onFocusLost: widget.onIndicesFocusLost),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: onDeleteButtonPress,
                    icon:
                        Icon(Icons.delete, color: _deleteButtonColor.toColor()),
                  ),
                  const Spacer()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onDeleteButtonPress() {
    widget.indicesTextController.clear();
    widget.variablesTextController.clear();

    const int timerDuration = 1000;
    int currentTime = 0;
    int incrementTime = 25;

    Timer.periodic(Duration(milliseconds: incrementTime), (Timer timer) {
      if (!mounted) {
        return;
      }

      setState(() {
        if (currentTime >= timerDuration) {
          timer.cancel();
        }

        _deleteButtonColor = HSVColor.lerp(_pressedDeleteButtonColor,
            _defaultDeleteButtonColor, currentTime / timerDuration) as HSVColor;

        currentTime += incrementTime;
      });
    });
  }
}
