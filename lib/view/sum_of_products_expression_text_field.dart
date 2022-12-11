import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proof_map/utils/messages.dart' as messages;
import 'package:proof_map/view/text_field.dart';

final TextEditingController _textController = TextEditingController();
final TextEditingController _variablesTextController = TextEditingController();

class SumOfProductsExpressionTextField extends ExpressionTextField {
  const SumOfProductsExpressionTextField({super.key});

  @override
  State<SumOfProductsExpressionTextField> createState() =>
      _SumOfProductsExpressionTextFieldState();

  @override
  String get text => _textController.text;

  String get variablesText => _variablesTextController.text;
}

class _SumOfProductsExpressionTextFieldState
    extends State<SumOfProductsExpressionTextField> {
  final HSVColor _defaultDeleteButtonColor =
      const HSVColor.fromAHSV(1, 238, 0.78, 0.96);
  final HSVColor _pressedDeleteButtonColor =
      const HSVColor.fromAHSV(1, 359, 0.78, 0.96);
  late HSVColor _deleteButtonColor = _defaultDeleteButtonColor;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Text("F (", style: TextStyle(fontSize: 18)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: IntrinsicWidth(
          child: TextField(
            controller: _variablesTextController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(1),
              hintText: "Variables",
            ),
          ),
        ),
      ),
      const Text(") = Σm(", style: TextStyle(fontSize: 18)),
      Expanded(
        flex: 6,
        child: TextField(
          controller: _textController,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(1),
              hintText: messages.mintermIndices),
        ),
      ),
      const Text(")", style: TextStyle(fontSize: 18)),
      IconButton(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: onDeleteButtonPress,
        icon: Icon(Icons.delete, color: _deleteButtonColor.toColor()),
      ),
    ]);
  }

  void onDeleteButtonPress() {
    _textController.clear();
    _variablesTextController.clear();

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
