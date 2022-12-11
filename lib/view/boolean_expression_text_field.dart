import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proof_map/utils/messages.dart' as messages;
import 'package:proof_map/view/text_field.dart';

final TextEditingController _textController = TextEditingController();

class BooleanExpressionTextField extends ExpressionTextField {
  const BooleanExpressionTextField({super.key});

  @override
  State<BooleanExpressionTextField> createState() =>
      _BooleanExpressionTextFieldState();

  String get text => _textController.text;
}

class _BooleanExpressionTextFieldState
    extends State<BooleanExpressionTextField> {
  final HSVColor _defaultDeleteButtonColor =
      const HSVColor.fromAHSV(1, 238, 0.78, 0.96);
  final HSVColor _pressedDeleteButtonColor =
      const HSVColor.fromAHSV(1, 359, 0.78, 0.96);
  late HSVColor _deleteButtonColor = _defaultDeleteButtonColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      onChanged: (value) {
        int offset = _textController.selection.baseOffset;
        _textController
          ..text = value.replaceAll("*", "·")
          ..selection = TextSelection.collapsed(offset: offset);
      },
      decoration: InputDecoration(
          hintText: messages.enterExpressionMessage,
          contentPadding: const EdgeInsets.all(20.0),
          suffixIcon: IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: onDeleteButtonPress,
              icon: Icon(Icons.delete, color: _deleteButtonColor.toColor()))),
    );
  }

  void onDeleteButtonPress() {
    _textController.clear();

    const int timerDuration = 1000;
    int currentTime = 0;
    int incrementTime = 25;

    Timer.periodic(Duration(milliseconds: incrementTime), (Timer timer) {
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
