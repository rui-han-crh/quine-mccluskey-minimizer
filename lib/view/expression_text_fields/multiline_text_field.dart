import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultilineTextField extends StatefulWidget {
  final TextEditingController textController;
  final String _hintText;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onFocusLost;

  const MultilineTextField(
    this._hintText, {
    Key? key,
    required this.textController,
    this.inputFormatters,
    this.onFocusLost,
  }) : super(key: key);

  @override
  State<MultilineTextField> createState() => _MultilineTextFieldState();
}

class _MultilineTextFieldState extends State<MultilineTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            widget.onFocusLost?.call(widget.textController.text);
          }
        },
        child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: widget.textController,
          inputFormatters: widget.inputFormatters,
          style: const TextStyle(fontSize: 22),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            isDense: true,
            hintText: widget._hintText,
          ),
        ),
      ),
    );
  }
}
