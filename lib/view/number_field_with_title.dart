import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberFieldWithTitle extends StatefulWidget {
  const NumberFieldWithTitle({
    Key? key,
    required this.title,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.onChange,
  }) : super(key: key);

  final String title;
  final Function(int?)? onChange;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? hintText;
  final TextStyle? hintStyle;

  @override
  State<NumberFieldWithTitle> createState() => NumberFieldWithTitleState();
}

class NumberFieldWithTitleState extends State<NumberFieldWithTitle> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.title),
        SizedBox(
          width: 50.0,
          height: 30,
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hintText ?? "",
              counterText: "",
              hintStyle: widget.hintStyle ?? const TextStyle(height: 0.5),
            ),
            style: widget.textStyle ?? const TextStyle(height: 0.9),
            keyboardType: TextInputType.number,
            maxLength: 2,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (value) => widget.onChange?.call(int.tryParse(value)),
          ),
        ),
      ],
    );
  }
}
