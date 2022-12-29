import 'package:flutter/material.dart';

class CheckboxWithTitle extends StatefulWidget {
  const CheckboxWithTitle({
    Key? key,
    required this.startingBooleanValue,
    required this.title,
    required this.onChecked,
  }) : super(key: key);

  final bool startingBooleanValue;
  final String title;
  final void Function(bool) onChecked;

  @override
  State<CheckboxWithTitle> createState() => CheckboxWithTitleState();
}

class CheckboxWithTitleState extends State<CheckboxWithTitle> {
  late bool isChecked = widget.startingBooleanValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.title),
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() => isChecked = value!);
            widget.onChecked(value!);
          },
        ),
      ],
    );
  }
}
