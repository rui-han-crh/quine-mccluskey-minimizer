import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:proof_map/view/expression_text_fields/multiline_text_field.dart';

class VariableRow extends StatefulWidget {
  final void Function(String)? onFocusLost;
  final TextEditingController variablesTextController;

  const VariableRow(
    this.variablesTextController, {
    Key? key,
    this.onFocusLost,
  }) : super(key: key);

  @override
  State<VariableRow> createState() => _VariableRowState();
}

class _VariableRowState extends State<VariableRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: Text(
            "F (",
            style: TextStyle(fontSize: 22),
          ),
        ),
        MultilineTextField(
          "Variables",
          textController: widget.variablesTextController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z, ]")),
          ],
          onFocusLost: widget.onFocusLost,
        ),
        const Align(
            alignment: Alignment.bottomLeft,
            child: Text(")", style: TextStyle(fontSize: 22))),
      ],
    );
  }
}
