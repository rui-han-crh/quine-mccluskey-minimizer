import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/utils/messages.dart' as messages;

final TextEditingController _textController = TextEditingController();

class AlgebraicExpressionTextField extends StatefulWidget {
  final Model model;
  const AlgebraicExpressionTextField({required this.model, super.key});

  @override
  State<AlgebraicExpressionTextField> createState() =>
      _AlgebraicExpressionTextFieldState();

  String get text => _textController.text;
}

class _AlgebraicExpressionTextFieldState
    extends State<AlgebraicExpressionTextField> {
  final HSVColor _defaultDeleteButtonColor =
      const HSVColor.fromAHSV(1, 238, 0.78, 0.96);
  final HSVColor _pressedDeleteButtonColor =
      const HSVColor.fromAHSV(1, 359, 0.78, 0.96);
  late HSVColor _deleteButtonColor = _defaultDeleteButtonColor;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.model.combinationalSolverState.algebraicExpression =
            _textController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        int offset = _textController.selection.baseOffset;
        _textController
          ..text = value.replaceAll("*", "·")
          ..selection = TextSelection.collapsed(offset: offset);
      },
      focusNode: _focusNode,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\+\-\(\)·\*\']"))
      ],
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: messages.enterExpressionMessage,
        contentPadding: const EdgeInsets.all(20.0),
        suffixIcon: IconButton(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: onDeleteButtonPress,
          icon: Icon(
            Icons.delete,
            color: _deleteButtonColor.toColor(),
          ),
        ),
      ),
    );
  }

  void onDeleteButtonPress() {
    _textController.clear();

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
