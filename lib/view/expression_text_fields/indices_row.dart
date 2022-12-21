import 'package:flutter/material.dart';
import 'package:proof_map/view/expression_text_fields/multiline_text_field.dart';

class IndicesRow extends StatelessWidget {
  final TextEditingController indicesTextController;
  final String termPrefix;
  final String termHintText;

  const IndicesRow(
      {required this.termPrefix,
      required this.termHintText,
      required this.indicesTextController,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "= $termPrefix(",
            style: const TextStyle(fontSize: 22),
          ),
        ),
        MultilineTextField(
          termHintText,
          textController: indicesTextController,
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
