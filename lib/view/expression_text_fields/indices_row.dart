import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proof_map/view/expression_text_fields/multiline_text_field.dart';

class IndicesRow extends StatefulWidget {
  final TextEditingController indicesTextController;
  final String termPrefix;
  final String termHintText;
  final void Function(String)? onFocusLost;

  const IndicesRow(
      {required this.termPrefix,
      required this.termHintText,
      required this.indicesTextController,
      this.onFocusLost,
      Key? key})
      : super(key: key);

  @override
  State<IndicesRow> createState() => _IndicesRowState();
}

class _IndicesRowState extends State<IndicesRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "= ${widget.termPrefix}(",
            style: const TextStyle(fontSize: 22),
          ),
        ),
        MultilineTextField(
          widget.termHintText,
          textController: widget.indicesTextController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[0-9, ]")),
          ],
          onFocusLost: widget.onFocusLost,
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            ")",
            style: TextStyle(fontSize: 22),
          ),
        ),
      ],
    );
  }
}
