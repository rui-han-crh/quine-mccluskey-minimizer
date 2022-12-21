import 'package:flutter/cupertino.dart';
import 'package:proof_map/view/expression_text_fields/multiline_text_field.dart';

class VariableRow extends StatelessWidget {
  final TextEditingController _variablesTextController;
  const VariableRow(this._variablesTextController, {Key? key})
      : super(key: key);

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
          textController: _variablesTextController,
        ),
        const Align(
            alignment: Alignment.bottomLeft,
            child: Text(")", style: TextStyle(fontSize: 22))),
      ],
    );
  }
}
