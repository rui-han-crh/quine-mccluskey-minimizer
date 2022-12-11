import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proof_map/model/model.dart';
import 'package:proof_map/utils/messages.dart' as messages;

class SubmitButton extends StatefulWidget {
  final Model _model;
  final Function()? _onClicked;
  final Function _getTextCallback;
  final Function(String) _assignResultCallback;

  SubmitButton(
      {super.key,
      required model,
      Function()? onClicked,
      required getTextCallback,
      required assignResultCallback})
      : _model = model,
        _getTextCallback = getTextCallback,
        _assignResultCallback = assignResultCallback,
        _onClicked = onClicked;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();

  final Row loadingStatus =
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

  final Row submitButtonText =
      Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
    Text(
      messages.toDnfText,
      style: TextStyle(color: Colors.white),
    )
  ]);

  Widget build(bool isSubmitted, Function() onSubmitButtonPress) {
    return Row(
      children: [
        const Text("Operation: "),
        const SizedBox(width: 20),
        Expanded(
            child: MaterialButton(
                onPressed: isSubmitted ? null : onSubmitButtonPress,
                color: Colors.blue,
                disabledColor: Colors.blue,
                child: isSubmitted ? loadingStatus : submitButtonText)),
      ],
    );
  }
}

class _SubmitButtonState extends State<SubmitButton> {
  bool _isSubmitted = false;

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
      messages.toDnfText,
      style: TextStyle(color: Colors.white),
    )
  ]);

  @override
  Widget build(BuildContext context) {
    return widget.build(_isSubmitted, onSubmitButtonPress);
  }

  Future<void> onSubmitButtonPress() async {
    widget._onClicked?.call();

    setState(() {
      _isSubmitted = true;
    });

    await widget._model
        .simplifyBooleanExpression(widget._getTextCallback())
        .then((value) => widget._assignResultCallback(value));
    setState(() {
      _isSubmitted = false;
    });
  }
}

class SumOfProductsSubmitButton extends SubmitButton {
  final Function _getVariablesCallback;

  SumOfProductsSubmitButton(
      {super.key,
      required super.model,
      super.onClicked,
      required getVariablesCallback,
      required super.getTextCallback,
      required super.assignResultCallback})
      : _getVariablesCallback = getVariablesCallback;

  @override
  State<SubmitButton> createState() => _SumOfProductsSubmitButtonState();
}

class _SumOfProductsSubmitButtonState extends State<SumOfProductsSubmitButton> {
  bool _isSubmitted = false;

  Future<void> onSubmitButtonPress() async {
    widget._onClicked?.call();

    setState(() {
      _isSubmitted = true;
    });

    await widget._model
        .simplifyFromMinterms(
          widget._getVariablesCallback(),
          widget._getTextCallback(),
        )
        .then((value) => widget._assignResultCallback(value));

    setState(() {
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(_isSubmitted, onSubmitButtonPress);
  }
}
