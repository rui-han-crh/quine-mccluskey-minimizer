import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class ImplicantTable extends StatelessWidget {
  final Iterable<String> tableHeaders;
  final Iterable<Iterable<String>> tableValues;

  const ImplicantTable(
      {Key? key, required this.tableHeaders, required this.tableValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tableHeaders.isEmpty || tableValues.isEmpty) {
      return Table();
    }

    assert(tableHeaders.length == tableValues.first.length,
        "Table headers (${tableHeaders.length}) and values (${tableValues.first.length}) must have the same length");

    List<TableCell> headerChildren = <TableCell>[];

    for (String header in tableHeaders) {
      headerChildren.add(TableCell(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).backgroundColor,
          child: Text(
            header,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ));
    }

    List<TableRow> tableChildren = <TableRow>[
      TableRow(children: headerChildren),
    ];

    for (Iterable<String> row in tableValues) {
      List<TableCell> rowChildren = <TableCell>[];
      for (String value in row) {
        rowChildren.add(TableCell(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(value),
          ),
        ));
      }
      tableChildren.add(TableRow(children: rowChildren));
    }

    return SizedBox(
      child: Table(
        border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline, width: 1),
        children: tableChildren,
      ),
    );
  }
}
