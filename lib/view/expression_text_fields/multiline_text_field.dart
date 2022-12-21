import 'package:flutter/material.dart';

class MultilineTextField extends StatelessWidget {
  final TextEditingController textController;
  final String _hintText;

  const MultilineTextField(this._hintText,
      {required this.textController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: textController,
        style: const TextStyle(fontSize: 22),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          isDense: true,
          hintText: _hintText,
        ),
      ),
    );
  }
}
