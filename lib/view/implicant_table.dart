import 'dart:developer';

import 'package:flutter/material.dart' hide TableCell;
import 'package:proof_map/model/literal_term.dart';

const double fontSize = 18;
const double padding = 4;

class ImplicantTable extends StatefulWidget {
  final Iterable<LiteralTerm> tableHeaders;
  final Iterable<Iterable<String>> tableValues;
  final void Function(List<String> newColumnHeaders) onColumnsChange;

  const ImplicantTable(
      {Key? key,
      required this.tableHeaders,
      required this.tableValues,
      required this.onColumnsChange})
      : super(key: key);

  @override
  State<ImplicantTable> createState() => _ImplicantTableState();
}

class _ImplicantTableState extends State<ImplicantTable> {
  // This is a state variable to get the table to update when the headers change
  List<LiteralTerm> columnHeaders = [];

  @override
  void initState() {
    super.initState();
    columnHeaders = widget.tableHeaders.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tableHeaders.isEmpty || widget.tableValues.isEmpty) {
      return SizedBox(
        child: Container(),
      );
    }

    assert(widget.tableHeaders.length == widget.tableValues.first.length,
        "Table headers (${widget.tableHeaders.length}) and values (${widget.tableValues.first.length}) must have the same length");

    List<TableColumn> columns = [];

    for (int i = 0; i < columnHeaders.length; i++) {
      LiteralTerm header = columnHeaders[i];
      LiteralTerm negation = columnHeaders[i].negate();
      columns.add(
        TableColumn(
          header: ImplicantTableHeader(
            text: header.postulate,
            color: Colors.grey[700]!,
            terms: {header.postulate: header, negation.postulate: negation},
            onHeaderChange: (LiteralTerm value) => setState(() {
              columnHeaders[i] = value;
              widget.onColumnsChange(
                  columnHeaders.map(((e) => e.postulate)).toList());
            }),
          ),
        ),
      );
    }

    bool isEven = false;

    for (Iterable<String> row in widget.tableValues) {
      for (int i = 0; i < row.length; i++) {
        columns[i].children.add(ImplicantTableCell(
            text: row.elementAt(i),
            color: isEven ? Colors.grey[700]! : Colors.grey[800]!));
      }
      isEven = !isEven;
    }

    void onReorder(int oldIndex, int newIndex) {
      setState(() {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final LiteralTerm item = columnHeaders.removeAt(oldIndex);
        columnHeaders.insert(newIndex, item);
        widget
            .onColumnsChange(columnHeaders.map(((e) => e.postulate)).toList());
      });
    }

    double multiplier = fontSize + padding * 2 + 11;

    return SizedBox(
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints:
              // multiplier is fontsize + padding * 2 + const 11
              BoxConstraints(
                  maxHeight: columns.first.children.length * multiplier),
          child: ReorderableList(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            onReorder: onReorder,
            itemCount: columns.length,
            itemBuilder: (context, index) => ReorderableDragStartListener(
                key: ValueKey(columns[index]),
                index: index,
                child: columns[index]),
          ),
        ),
      ),
    );
  }
}

class TableColumn extends StatelessWidget {
  TableColumn({
    Key? key,
    required this.header,
  }) : super(key: key);

  final ImplicantTableHeader header;

  late final List<Widget> children = [header];

  late final Column column = Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: children,
  );

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(child: column);
  }
}

class ImplicantTableCell extends StatefulWidget {
  const ImplicantTableCell({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  State<ImplicantTableCell> createState() => _ImplicantTableCellState();
}

class _ImplicantTableCellState extends State<ImplicantTableCell> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: widget.color,
        padding: const EdgeInsets.symmetric(
            vertical: padding, horizontal: padding * 2),
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: fontSize),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ImplicantTableHeader extends ImplicantTableCell {
  final Map<String, LiteralTerm> terms;
  final void Function(LiteralTerm) onHeaderChange;

  const ImplicantTableHeader({
    Key? key,
    required String text,
    required Color color,
    required this.terms,
    required this.onHeaderChange,
  }) : super(key: key, text: text, color: color);

  @override
  State<ImplicantTableCell> createState() => _ImplicantTableHeaderState();
}

class _ImplicantTableHeaderState extends State<ImplicantTableHeader> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: Container(
          color: widget.color,
          padding: const EdgeInsets.symmetric(
              vertical: padding, horizontal: padding * 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 15,
              ),
              elevation: 16,
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                  widget.onHeaderChange(widget.terms[dropdownValue]!);
                });
              },
              items: widget.terms.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
