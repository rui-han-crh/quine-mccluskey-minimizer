import 'package:flutter/material.dart';
import 'package:proof_map/view/utils/expression_form.dart';

const List<ExpressionForm> list = [
  ExpressionForm.algebraic,
  ExpressionForm.minterms
];

class DropdownExpressionForm extends StatefulWidget {
  final Function(ExpressionForm) _changeExpressionFormCallback;

  const DropdownExpressionForm(
      {super.key, required changeExpressionFormCallback})
      : _changeExpressionFormCallback = changeExpressionFormCallback;

  @override
  State<DropdownExpressionForm> createState() => _DropdownExpressionFormState();
}

class _DropdownExpressionFormState extends State<DropdownExpressionForm> {
  ExpressionForm dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      const Text("Expression Form: "),
      const SizedBox(width: 10),
      DropdownButton<ExpressionForm>(
        value: dropdownValue,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (ExpressionForm? value) {
          // This is called when the user selects an item.
          setState(
            () {
              dropdownValue = value!;
              widget._changeExpressionFormCallback(dropdownValue);
            },
          );
        },
        items:
            list.map<DropdownMenuItem<ExpressionForm>>((ExpressionForm value) {
          return DropdownMenuItem<ExpressionForm>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),
      )
    ]);
  }
}
