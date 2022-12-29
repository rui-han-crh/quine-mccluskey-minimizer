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
    this.onFocusLost,
  }) : super(key: key);

  final String title;
  final void Function(int?)? onFocusLost;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? hintText;
  final TextStyle? hintStyle;

  @override
  State<NumberFieldWithTitle> createState() => NumberFieldWithTitleState();
}

class NumberFieldWithTitleState extends State<NumberFieldWithTitle> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onFocusLost?.call(int.tryParse(_textEditingController.text));
      }
    });
  }

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
          ),
        ),
      ],
    );
  }
}
