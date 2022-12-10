import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/utils/messages.dart' as messages;

class HomePage extends StatefulWidget {
  final Model _model;
  const HomePage(this._model, {super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final EdgeInsets paddingInsets = const EdgeInsets.all(20.0);

  final TextEditingController _textController = TextEditingController();

  final HSVColor _defaultDeleteButtonColor =
      const HSVColor.fromAHSV(1, 238, 0.78, 0.96);
  final HSVColor _pressedDeleteButtonColor =
      const HSVColor.fromAHSV(1, 359, 0.78, 0.96);
  late HSVColor _deleteButtonColor = _defaultDeleteButtonColor;

  bool _isSubmitted = false;
  String? result;

  Row loadingStatus =
      Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
    Text(
      messages.expressionSubmittedText,
      style: TextStyle(color: Colors.white),
    ),
    SizedBox(width: 10),
    SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(color: Colors.white))
  ]);

  Row submitButtonText =
      Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
    Text(
      messages.simplifyText,
      style: TextStyle(color: Colors.white),
    )
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: paddingInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _generatedExpressionTextField(),
                const SizedBox(height: 10),
                _generateSubmitButton(),
                _generateResultText(),
              ],
            )));
  }

  Future<void> onSubmitButtonPress() async {
    log(_textController.text);
    setState(() {
      _isSubmitted = true;
    });

    await widget._model
        .simplifyBooleanExpression(_textController.text)
        .then((value) => result = value);
    setState(() {
      _isSubmitted = false;
    });
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

  TextField _generatedExpressionTextField() {
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
          contentPadding: paddingInsets,
          suffixIcon: IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: onDeleteButtonPress,
              icon: Icon(Icons.delete, color: _deleteButtonColor.toColor()))),
    );
  }

  MaterialButton _generateSubmitButton() {
    return MaterialButton(
        onPressed: _isSubmitted ? null : onSubmitButtonPress,
        color: Colors.blue,
        disabledColor: Colors.blue,
        child: _isSubmitted ? loadingStatus : submitButtonText);
  }

  Expanded _generateResultText() {
    return Expanded(
        child: Center(
            child: Text(
      result == null ? "" : result.toString(),
      style: const TextStyle(fontSize: 20),
    )));
  }
}
